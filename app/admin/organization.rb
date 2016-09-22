ActiveAdmin.register Organization do

permit_params :name, :intro, :sort, :users_count, { detail_images: [] }

index do
  selectable_column
  column('ID',:id)
  column(:name, sortable: false)
  column :detail_images, sortable: false do |organ|
    html = ''
    organ.detail_images.each do |img|
      html += image_tag(img.url(:small), size: '80x80')
    end
    raw(html)
  end
  column :users_count
  column :sort
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :name
    f.input :detail_images, as: :file, required: true, input_html: { multiple: true }, hint: '支持图片广告或视频广告上传，支持多个文件上传，图片格式为：jpg, jpeg, png, gif'
    f.input :intro
    f.input :sort, hint: '值越大显示越靠前'
  end
    
  actions
  
end


end
