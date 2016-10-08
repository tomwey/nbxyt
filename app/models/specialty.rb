class Specialty < ActiveRecord::Base
  validates :name, :faculty_id, presence: true
  belongs_to :faculty
end
