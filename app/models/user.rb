require 'rest-client'
class User < ActiveRecord::Base  
  has_secure_password
  
  validates :mobile, :password, :password_confirmation, presence: true, on: :create
  validates :mobile, format: { with: /\A1[3|4|5|7|8][0-9]\d{4,8}\z/, message: "请输入11位正确手机号" }, length: { is: 11 }, :uniqueness => true
            
  mount_uploader :avatar, AvatarUploader
  
  scope :no_delete, -> { where(visible: true) }
  scope :verified,  -> { where(verified: true) }
    
  def hack_mobile
    return "" if self.mobile.blank?
    hack_mobile = String.new(self.mobile)
    hack_mobile[3..6] = "****"
    hack_mobile
  end
  
  def real_avatar_url(size = :large)
    if avatar.blank?
      "avatar/#{size}.png"
    else
      avatar.url(size)
    end
  end
  
  # 获取默认的收货地址
  # def current_shipment
  #   @current_shipment ||= Shipment.find_by(id: self.current_shipment_id)
  # end
  
  # 生成token
  before_create :generate_private_token
  def generate_private_token
    self.private_token = SecureRandom.uuid.gsub('-', '') if self.private_token.blank?
  end
  
  # 返回二维码图片地址
  def qrcode_url
    SiteConfig.root_url || Setting.upload_url + "/uploads/user/#{self.uid}/qrcode.png"
  end
  
  # 禁用账户
  def block!
    self.verified = false
    self.save!
  end
  
  # 启用账户
  def unblock!
    self.verified = true
    self.save!
  end
  
  # 设置支付密码
  # def pay_password=(password)
  #   self.pay_password_digest = BCrypt::Password.create(password) if self.pay_password_digest.blank?
  # end
  
  # 更新支付密码
  def update_pay_password!(password)
    return false if password.blank?
    self.pay_password_digest = BCrypt::Password.create(password)
    self.save!
  end
  
  # 检查支付密码是否正确
  def is_pay_password?(password)
    return false if self.pay_password_digest.blank?
    BCrypt::Password.new(self.pay_password_digest) == password
  end
  
end
