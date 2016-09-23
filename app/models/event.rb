class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true
  
  validates :title, :body, :started_at, :ended_at, :eventable_type, :eventable_id, presence: true
  
  scope :latest_starting, -> { where('started_at > ?', Time.zone.now).order('started_at asc') } 
  scope :ended, -> { where('ended_at < ?', Time.zone.now).order('ended_at desc') }
  
  mount_uploader :image, ImageUploader
  
  def image_url
    if image.blank?
      ''
    else
      image.url(:large)
    end
  end
end
