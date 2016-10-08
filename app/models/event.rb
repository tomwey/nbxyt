class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true
  
  validates :title, :body, :started_at, :ended_at, :eventable_type, :eventable_id, presence: true
  
  scope :latest_starting, -> { where('started_at > ?', Time.zone.now).order('started_at asc') } 
  scope :ended, -> { where('ended_at < ?', Time.zone.now).order('ended_at desc') }
  
  mount_uploader :image, ImageUploader
  
  def image_url(size = :large)
    if image.blank?
      ''
    else
      image.url(size)
    end
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
