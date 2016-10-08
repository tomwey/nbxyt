class Graduation < ActiveRecord::Base
  validates :name, presence: true
end
