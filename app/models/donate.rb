class Donate < ActiveRecord::Base
  validates :title, :intro, :body, :image, :donated_on, presence: true
  
  mount_uploader :image, ImageUploader
  
  def as_json(opts = {})
    {
      id: self.id,
      title: self.title,
      intro: self.intro || '',
      image: self.image_url,
      donated_on: self.donated_on.strftime('%Y-%m-%d')
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
