class Order < ActiveRecord::Base
  # belongs_to :product, counter_cache: true
  belongs_to :user
  
  validates :user_id, :product_id, presence: true
  
  # 定义状态机
  state_machine initial: :pending do # 默认状态
    state :paid      # 已支付，待配送
    state :shipping  # 配送中
    state :canceled  # 已取消
    state :completed # 已完成
    
    # 支付
    after_transition :pending => :paid do |order, transition|
      # order.send_pay_msg
    end
    event :pay do
      transition :pending => :paid
    end
    
    # 配送
    after_transition :paid => :shipping do |order, transition|
      # order.send_order_state_msg('订单配送中，请耐心等待:)', '已发货')
      order.send_notification('商品配送中，请耐心等待')
    end
    event :ship do
      transition :paid => :shipping
    end
    
    # 取消订单
    # 只能系统管理员取消订单
    after_transition [:pending, :paid] => :canceled do |order, transition|
      # order.send_order_state_msg('系统取消了您的订单', '已取消')
      order.send_notification('系统取消了您的订单')
    end
    event :cancel do
      transition [:pending, :paid] => :canceled
    end
    
    # 确认完成订单，系统管理员确认
    after_transition :shipping => :completed do |order, transition|
      # order.send_order_state_msg('您已经完成了本次购物，谢谢惠顾！', '已完成', '欢迎到微信跟我们留言互动，多提意见！我们会加倍努力的哟:)')
      order.send_notification('您已经完成了本次兑换，请继续使用得益WIFI')
    end
    event :complete do
      transition :shipping => :completed
    end
  end 
  
  def send_notification(msg)
    return if user.blank? or user.uid.blank? or msg.blank?
    PushService.push_to(msg, ["#{user.uid}"])
  end
  
  # 生成订单号
  before_create :generate_order_no
  def generate_order_no
    self.order_no = Time.now.to_s(:number)[2,6] + (Time.now.to_i - Date.today.to_time.to_i).to_s + Time.now.nsec.to_s[0,6]
  end
  
  def shipment
    @shipment ||= Shipment.find_by(id: shipment_id)
  end
  
  def product_title
    product.try(:title) || ''
  end
  
  def product_small_image
    if product.image
      product.image.url(:small)
    else
      ''
    end
  end
  
  def product_price
    return 0 if quantity == 0
    total_fee / quantity
  end
  
  def state_info
    I18n.t("common.#{state}")
  end
  
end
