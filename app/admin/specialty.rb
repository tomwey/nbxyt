ActiveAdmin.register Specialty do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model

menu parent: 'school_info'

permit_params :name, :sort, :faculty_id

index do
  selectable_column
  column :id
  column :name, sortable: false
  column '所属院系', sortable: false do |s|
    s.faculty.name
  end
  column :sort
  column :created_at
  column :updated_at
  actions
end

end
