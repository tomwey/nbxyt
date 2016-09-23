ActiveAdmin.register Club do

permit_params :name, :title, :body, :sort

index do
  selectable_column
  column('ID',:id)
  column :name,  sortable: false
  column :title, sortable: false
  # column :body,  sortable: false
  column :sort
  actions defaults: false do |club|
    item "查看", cpanel_club_path(club)
    item "编辑", edit_cpanel_club_path(club)
    item "删除", cpanel_club_path(club), method: :delete, data: { confirm: '您确定吗？' }
    item "新建活动", new_cpanel_event_path(id: club.id, type: club.class)
  end
end

end
