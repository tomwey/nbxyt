ActiveAdmin.register User do

menu parent: 'user'

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :balance
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

actions :index, :edit, :update

filter :nickname
filter :mobile
filter :private_token
filter :created_at

scope 'all', default: true do |users|
  users.no_delete
end

scope '正常用户', :verified do |users|
  users.no_delete.verified
end

index do
  selectable_column
  column :id
  column :avatar, sortable: false do |u|
    u.avatar.blank? ? "" : image_tag(u.avatar.url(:normal))
  end
  column '用户信息', sortable: false do |u|
    raw("UID: #{u.uid}<br>昵称: #{u.nickname}<br>手机: #{u.mobile}")
  end
  column 'TOKEN', sortable: false do |u|
    u.private_token
  end
  column :realname, sortable: false
  column :stu_no, sortable: false
  column '院系专业', sortable: false do |u|
    u.full_school_info
  end
  column :is_mentor, sortable: false do |u|
    u.is_mentor ? '是' : '否'
  end
  column :is_valid, sortable: false do |u|
    u.is_valid ? '已确认' : '未确认'
  end
  column :verified, sortable: false do |u|
    u.verified ? '已启用' : '已禁用'
  end
  column :created_at
  
  actions defaults: false do |u|
    if u.verified
      item "禁用", block_cpanel_user_path(u), method: :put
    else
      item "启用", unblock_cpanel_user_path(u), method: :put
    end
    if u.is_mentor
      item "取消导师身份", cancel_mentor_cpanel_user_path(u), method: :put
    else
      item "成为导师", set_mentor_cpanel_user_path(u), method: :put
    end
    
    if not u.is_valid
      item "确认身份", set_valid_cpanel_user_path(u), method: :put, data: { confirm: '你确定吗？' }
    end
  end
end

# 批量禁用账号
batch_action :block do |ids|
  batch_action_collection.find(ids).each do |user|
    user.block!
  end
  redirect_to collection_path, alert: "已经禁用"
end

# 批量启用账号
batch_action :unblock do |ids|
  batch_action_collection.find(ids).each do |user|
    user.unblock!
  end
  redirect_to collection_path, alert: "已经启用"
end

member_action :block, method: :put do
  resource.block!
  redirect_to collection_path, notice: "已禁用"
end

member_action :unblock, method: :put do
  resource.unblock!
  redirect_to collection_path, notice: "取消禁用"
end

# 批量成为导师
batch_action :set_mentor do |ids|
  batch_action_collection.find(ids).each do |user|
    user.set_mentor!
  end
  redirect_to collection_path, alert: "已经设置成导师"
end

# 批量取消导师身份
batch_action :cancel_mentor do |ids|
  batch_action_collection.find(ids).each do |user|
    user.cancel_mentor!
  end
  redirect_to collection_path, alert: "已经取消导师身份"
end

member_action :set_mentor, method: :put do
  resource.set_mentor!
  redirect_to collection_path, notice: "已经设置成导师"
end

member_action :cancel_mentor, method: :put do
  resource.cancel_mentor!
  redirect_to collection_path, notice: "已经取消导师身份"
end

# 确认校友身份
batch_action :set_valid do |ids|
  batch_action_collection.find(ids).each do |user|
    user.set_valid!
  end
  redirect_to collection_path, alert: "已经确认身份"
end

member_action :set_valid, method: :put do
  resource.set_valid!
  redirect_to collection_path, notice: "已经确认身份"
end

# member_action :pay_in, label: '充值', method: [:get, :put] do
#   if request.put?
#     resource.balance += params[:money]
#     resource.save!
#     head :ok
#   else
#     render :pay_in
#   end
# end

end
