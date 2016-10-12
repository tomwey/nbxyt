ActiveAdmin.register Donate do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

menu parent: 'donate_info'

permit_params :title, :intro, :body, :image, :sort, :donated_on, :donator_name, :donator_contact

index do
  selectable_column
  column('#',:id) { |donate| link_to donate.id, cpanel_donate_path(donate) }
  column(:title, sortable: false) { |donate| link_to donate.title, cpanel_donate_path(donate) }
  column :intro, sortable: false
  column :image, sortable: false do |donate|
    donate.image.blank? ? '' : image_tag(donate.image.url(:small))
  end
  column :donated_on
  column :donator_name, sortable: false
  column :donator_contact, sortable: false
  column '创建时间', :created_at
  column '更新时间', :updated_at
  actions
end

show do |donate|
  donate.body.html_safe
end

form do |f|
  f.inputs '捐赠项目信息' do
    f.input :title, placeholder: '项目标题，例如：某某向生病女孩捐款10万元'
    f.input :intro, placeholder: '项目简要描述'
    f.input :body, as: :text, input_html: { class: 'redactor' }, placeholder: '项目详情，支持图文混排', hint: '项目详情，支持图文混排'
    f.input :donated_on, as: :string, placeholder: '例如：2016-10-01'
    f.input :image, as: :file, hint: '支持jpg, png, gif格式'
  end
  f.inputs '捐赠人信息' do
    f.input :donator_name, placeholder: '姓名'
    f.input :donator_contact, placeholder: '电话，微信，QQ，邮箱等等'
  end
  actions
end


end
