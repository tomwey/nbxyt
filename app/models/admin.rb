class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  
  # 超级管理员
  def super_admin?
    Setting.admin_emails.include?(self.email)
  end
  
  # 管理员
  def admin?
    super_admin? || self.role.to_sym == :admin
  end
  
  # 站点编辑人员
  def site_editor?
    admin? || self.role.to_sym == :site_editor
  end
  
  # 校友会管理员
  def organization_manager?
    admin? || self.role.to_sym == :organization_manager
  end
  
  # 校友俱乐部管理员
  def club_manager?
    admin? || self.role.to_sym == :club_manager
  end
  
  def self.roles
    if CommonConfig.roles
      CommonConfig.roles.split(',')
    else
      []
    end
  end
  
  def role_name
    return '管理员' if super_admin?
    return '' if role.blank?
    I18n.t("common.#{role}")
  end
  
  # def roles?(role)
  #   role_sym = role.to_sym
  #   case role_sym
  #   when :super_admin then super_admin?
  #   when :admin then admin?
  #   when :site_editor then site_editor?
  #   when :marketer then marketer?
  #   else false
  #   end
  # end
  
end
