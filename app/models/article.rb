class Article < ActiveRecord::Base
  validates :title, :body, :node_id, presence: true
  belongs_to :node
  
  mount_uploader :image, AvatarUploader
  
  before_save :set_published_at
  def set_published_at
    if self.published_at.blank?
      self.published_at = Time.zone.now
    end
  end
end
