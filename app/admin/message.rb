ActiveAdmin.register Message do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :content

actions :all, except: [:edit, :update]

index do
  selectable_column
  column('#', :id)
  column :title, sortable: false
  column :content, sortable: false
  column '用户', sortable: false do |msg|
    msg.to.blank? ? '所有用户' : msg.user.try(:nickname) || msg.user.try(:hack_mobile)
  end
  column '消息查看时间' do |msg|
    msg.read_at || '-'
  end
  column :created_at
  actions
end

form do |f|
  f.inputs '新建消息' do
    f.input :title
    f.input :content
  end
  actions
end

end
