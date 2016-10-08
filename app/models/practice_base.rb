class PracticeBase < ActiveRecord::Base
  belongs_to :user
  has_many :events, as: :eventable
  
  validates :name, :address, :intro, :image, :body, :user_id, presence: true
  
  mount_uploader :image, ImageUploader
end
