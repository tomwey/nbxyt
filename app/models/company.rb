class Company < ActiveRecord::Base
  belongs_to :user
  
  validates :name, :address, :image, :body, presence: true
  
  mount_uploader :image, ImageUploader
  
end
