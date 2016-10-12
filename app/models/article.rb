class Article < ActiveRecord::Base
  validates :title, :body, :node_id, presence: true
  belongs_to :node
  
  mount_uploader :image, ImageUploader
  
  before_save :set_published_at
  def set_published_at
    if self.published_at.blank?
      self.published_at = Time.zone.now
    end
  end
  
  def as_json(opts = {})
    {
      id: self.id,
      title: self.title,
      intro: self.intro || '',
      image: self.image_url,
      published_at: self.published_at.strftime('%Y-%m-%d'),
      has_image: self.image.present?,
      node: {
        id: node.id,
        name: node.name,
      }
    }
  end
  
  def image_url
    if image.blank?
      ''
    else
      image.url(:thumb)
    end
  end
  
end
