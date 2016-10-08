class Faculty < ActiveRecord::Base
  validates :name, presence: true
end
