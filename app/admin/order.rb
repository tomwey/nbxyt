ActiveAdmin.register Order do
  
  # menu priority: 10
  menu parent: 'shop'
  
  actions :index, :show#, :edit, :update

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :note, :quantity, :total_fee
#
# or
#

index do
  selectable_column
  column('ID', :id) { |order| link_to order.id, cpanel_order_path(order) }
  column(:order_no, sortable: false) { |order| link_to order.order_no, cpanel_order_path(order) }
  column :total_fee
  column :quantity
  column '收货信息', sortable: false do |order|
    if order.shipment.blank?
      '虚拟商品，没有收货信息'
    else
      raw("#{order.shipment.try(:name)}<br>#{order.shipment.try(:mobile)}<br>#{order.shipment.try(:address)}")
    end
  end
  column :state, sortable: false do |order|
    order.state_info
  end
  # column :note, sortable: false
  column '下单时间', :created_at
  column '下单人', sortable: false do |order|
    order.user.try(:nickname) || order.user.try(:mobile)
  end
  
  actions defaults: false do |order|
    # item '编辑', edit_admin_order_path(order)
    if order.can_cancel?
      item '取消订单 ', cancel_cpanel_order_path(order), method: :put
    end
    if order.can_ship?
      item '配送订单 ', ship_cpanel_order_path(order), method: :put
    end
    if order.can_complete?
      item '完成订单 ', complete_cpanel_order_path(order), method: :put
    end
  end
  
end

# 批量取消订单
batch_action :cancel do |ids|
  batch_action_collection.find(ids).each do |order|
    order.cancel
    # order.send_order_state_msg('系统人工取消了您的订单', '已取消')
  end
  redirect_to collection_path, alert: "已经取消"
end

# 批量更改配送状态
batch_action :ship do |ids|
  batch_action_collection.find(ids).each do |order|
    user.ship
  end
  redirect_to collection_path, alert: "已经更改为配送中"
end

# 批量完成订单
batch_action :complete do |ids|
  batch_action_collection.find(ids).each do |order|
    user.complete
  end
  redirect_to collection_path, alert: "已经完成订单"
end

member_action :cancel, method: :put do
  resource.cancel
  # resource.send_order_state_msg('系统人工取消了您的订单', '已取消')
  redirect_to collection_path, notice: "已取消"
end

member_action :ship, method: :put do
  resource.ship
  redirect_to collection_path, notice: "配送中"
end

member_action :complete, method: :put do
  resource.complete
  redirect_to collection_path, notice: "已完成"
end

show do
  attributes_table do
    row :order_no
    row '产品标题' do |order|
      order.product_title
    end
    row '产品图片' do |order|
      image_tag order.product_small_image
    end
    row '产品价格' do |order|
      order.product_price
    end
    row :note
    
  end
end

form do |f|
  f.semantic_errors
  
  f.inputs '修改订单' do
    f.input :note
    f.input :quantity
    f.input :total_fee
  end
  actions
end


end
