ActiveAdmin.register College do

permit_params :name, :admin_id

index do
  selectable_column
  column('ID',:id)
  column :name,  sortable: false
  column :mentors_count
  column '管理员', sortable: false do |college|
    college.admin.try(:email)
  end
  actions
end

form do |f|
  f.inputs do
    f.input :name
    f.input :admin_id, as: :select, collection: College.admins, prompt: '-- 选择管理员 --'
  end
  actions
end

end
