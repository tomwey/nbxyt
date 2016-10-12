class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true
  
  validates :title, :body, :image, :started_at, :ended_at, :eventable_type, :eventable_id, presence: true
  
  scope :latest_starting, -> { where('started_at > ?', Time.zone.now).order('started_at asc') } 
  scope :ended, -> { where('ended_at < ?', Time.zone.now).order('ended_at desc') }
  scope :recent, -> { order('started_at desc, id desc') }
  
  mount_uploader :image, ImageUploader
  
  def image_url(size = :large)
    if image.blank?
      ''
    else
      image.url(size)
    end
  end
  
  def state(opts, from_detail)
    result = {}
    if self.ended_at < Time.zone.now
      result[:label] = '已结束'
      result[:can_attend] = false
    else
      if from_detail
        if has_attended_for?(opts)
          result[:label] = '已报名'
          result[:can_attend] = false
        else
          result[:label] = '报名参加'
          result[:can_attend] = true
        end
      else
        result[:label] = '可参加'
        result[:can_attend] = true
      end
    end
    result
  end
  
  def has_attended_for?(opts)
    if opts.blank?
      false
    else
      opts = opts[:opts]
      if opts.blank?
        false
      else
        user = opts[:user]
        if user.blank?
          false
        else
          user.has_attended?(self)
        end
      end
    end
  end
end
