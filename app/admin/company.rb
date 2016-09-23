ActiveAdmin.register Company do

permit_params :name, :address, :image, :sort, :mentor_id, :intro, :link

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
    item "查看", cpanel_company_path(comp)
    item "编辑", edit_cpanel_company_path(comp)
    item "删除", cpanel_company_path(comp), method: :delete, data: { confirm: '您确定吗？' }
    item "新建活动", new_cpanel_event_path(id: comp.id, type: comp.class)
  end
end


form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :name
    f.input :address
    f.input :image, as: :file, hint: '图片格式为：jpg, jpeg, png, gif'
    f.input :intro
    f.input :link, placeholder: 'http://', hint: '公司网址'
    f.input :mentor_id, as: :select, collection: Mentor.where(verified: true).map { |mentor| [mentor.name, mentor.id] }, prompt: '-- 选择校友导师 --'
    f.input :sort, hint: '值越大显示越靠前'
  end
    
  actions
  
end

end
