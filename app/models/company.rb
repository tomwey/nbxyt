class Company < ActiveRecord::Base
  belongs_to :mentor
  
  validates :name, :address, :image, presence: true
  
  mount_uploader :image, ImageUploader
  
end
