ActiveAdmin.register Organization do

permit_params :name, :intro, :sort, :image, :body, :founded_on

index do
  selectable_column
  column('ID',:id)
  column(:name, sortable: false)
  column :intro, sortable: false
  column :image, sortable: false do |organ|
    organ.image.blank? ? '' : image_tag(organ.image.url(:small))
  end
  column :relationships_count
  column :founded_on
  column :sort
  actions defaults: false do |organ|
    item "编辑", edit_cpanel_organization_path(organ)
    item "删除", cpanel_organization_path(organ), method: :delete, data: { confirm: '您确定吗？' }
    item "新建活动", new_cpanel_event_path(type: organ.class, id: organ.id), method: :get
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :name
    f.input :image, as: :file, hint: '图片格式为：jpg, jpeg, png, gif'
    f.input :intro
    f.input :body, as: :text, input_html: { class: 'redactor' }, placeholder: '详情，支持图文混排', hint: '详情，支持图文混排'
    f.input :founded_on, as: :string, placeholder: '例如：2016-01-01'
    f.input :sort, hint: '值越大显示越靠前'
  end
    
  actions
  
end


end
