class Donate < ActiveRecord::Base
  validates :title, :intro, :body, :image, :donated_on, presence: true
  
  mount_uploader :image, AvatarUploader
end
