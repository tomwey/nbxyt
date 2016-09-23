class College < ActiveRecord::Base
  belongs_to :admin
  validates :name, :admin_id, presence: true
  
  def self.admins
    Admin.where(role: 'college_manager').map { |admin| [admin.email, admin.id] }
  end
end
