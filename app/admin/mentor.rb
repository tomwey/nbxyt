ActiveAdmin.register Mentor do

actions :index
  
index do
  selectable_column
  column('ID',:id)
  column '所属学院', sortable: false do |mentor|
    mentor.college.try(:name)
  end
  column :name, sortable: false
  column '个人信息', sortable: false do |mentor|
    mentor.user.try(:nickanme) || mentor.user.try(:hack_mobile)
  end 
  column :verified, sortable: false
  column :created_at
  actions defaults: false do |mentor|
    if mentor.verified
      item "取消审核", cancel_verify_cpanel_mentor_path(mentor), method: :put
    else
      item "确认审核", verify_cpanel_mentor_path(mentor), method: :put
    end
  end
  
end

# 批量审核
batch_action :verify do |ids|
  batch_action_collection.find(ids).each do |obj|
    obj.verify!
  end
  redirect_to collection_path, alert: "已经审核"
end

batch_action :cancel_verify do |ids|
  batch_action_collection.find(ids).each do |obj|
    obj.cancel_verify!
  end
  redirect_to collection_path, alert: "已经取消审核"
end

member_action :verify, method: :put do
  resource.verify!
  redirect_to collection_path, notice: "已审核"
end

member_action :cancel_verify, method: :put do
  resource.cancel_verify!
  redirect_to collection_path, notice: "已取消审核"
end

end
