class Club < ActiveRecord::Base
  validates :name, :title, :body, presence: true
  
  has_many :relationships, as: :relationshipable, dependent: :destroy
  has_many :users, through: :relationships
end
