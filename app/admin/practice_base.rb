ActiveAdmin.register PracticeBase do

permit_params :name, :address, :image, :sort, :user_id, :intro, :body

index do
  selectable_column
  column('ID',:id)
  column :name,  sortable: false
  column :address, sortable: false
  column :image, sortable: false do |comp|
    if comp.image.blank?
      ''
    else
      image_tag comp.image.url(:small)
    end
  end
  column :sort
  actions defaults: false do |comp|
    item "查看", cpanel_practice_basis_path(comp)
    item "编辑", edit_cpanel_practice_basis_path(comp)
    item "删除", cpanel_practice_basis_path(comp), method: :delete, data: { confirm: '您确定吗？' }
    item "新建活动", new_cpanel_event_path(owner_id: comp.id, owner_type: comp.class)
  end
end


form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :name
    f.input :address
    f.input :image, as: :file, hint: '图片格式为：jpg, jpeg, png, gif'
    f.input :intro
    f.input :body, as: :text, input_html: { class: 'redactor' }, placeholder: '基地详情，支持图文混排', hint: '基地详情，支持图文混排'
    f.input :user_id, as: :select, collection: User.where(is_mentor: true, is_valid: true, verified: true).map { |user| [user.realname, user.id] }, prompt: '-- 选择校友导师 --', required: true
    f.input :sort, hint: '值越大显示越靠前'
  end
    
  actions
  
end

end
