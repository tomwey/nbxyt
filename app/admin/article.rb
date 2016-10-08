ActiveAdmin.register Article do

  menu parent: 'donate_info'
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :intro, :body, :image, :published_at, :sort, :node_id
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
  selectable_column
  column('#',:id) { |article| link_to article.id, cpanel_article_path(article) }
  column(:title, sortable: false) { |article| link_to article.title, cpanel_article_path(article) }
  column :intro, sortable: false
  column :image, sortable: false do |article|
    article.image.blank? ? '' : image_tag(article.image.url(:large))
  end
  column :published_at
  column '创建时间', :created_at
  column '更新时间', :updated_at
  actions
end

show do |article|
  article.body.html_safe
end

form do |f|
  f.inputs '捐赠项目信息' do
    f.input :node_id, as: :select, collection: Node.all.map{ |node| [node.name, node.id] }, required: true
    f.input :title
    f.input :intro, placeholder: '可选'
    f.input :body, as: :text, input_html: { class: 'redactor' }, placeholder: '项目详情，支持图文混排', hint: '项目详情，支持图文混排'
    f.input :published_at, as: :string, placeholder: '例如：2016-10-01 12:30:00'
    f.input :image, as: :file, hint: '支持jpg, png, gif格式'
  end
  actions
end


end
