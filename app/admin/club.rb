ActiveAdmin.register Club do

permit_params :name, :title, :body, :sort, :intro, :image, :bylaw, :founded_on

index do
  selectable_column
  column('ID',:id)
  column :name,  sortable: false
  column :title, sortable: false
  column :intro, sortable: false
  column :image, sortable: false do |club|
    club.image.blank? ? '' : image_tag(club.image.url(:small))
  end
  column :relationships_count
  # column :body,  sortable: false
  column :sort
  actions defaults: false do |club|
    item "查看", cpanel_club_path(club)
    item "编辑", edit_cpanel_club_path(club)
    item "删除", cpanel_club_path(club), method: :delete, data: { confirm: '您确定吗？' }
    item "新建活动", new_cpanel_event_path(id: club.id, type: club.class)
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :name
    f.input :title
    f.input :image, as: :file, hint: '图片格式为：jpg, jpeg, png, gif'
    f.input :intro
    f.input :body, as: :text, input_html: { class: 'redactor' }, placeholder: '详情，支持图文混排', hint: '详情，支持图文混排'
    f.input :bylaw, as: :text
    f.input :founded_on, as: :string, placeholder: '例如：2016-01-01'
    f.input :sort, hint: '值越大显示越靠前'
  end
    
  actions
  
end

end
