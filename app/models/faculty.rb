class Faculty < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :specialties
end
