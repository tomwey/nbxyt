class Organization < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :user_organizations, dependent: :destroy
  has_many :users, through: :user_organizations
  
  has_many :events, as: :eventable
  
  scope :sorted, -> { order('sort desc, id desc') }
  
  mount_uploaders :detail_images, ImagesUploader
end
