ActiveAdmin.register Reply do

  actions :index, :destroy
  
  index do
    selectable_column
    column('ID',:id)
    column '发送者', sortable: false do |reply|
      reply.from_user.try(:nickname) || reply.from_user.try(:hack_mobile)
    end
    column '接收者', sortable: false do |reply|
      reply.to_user.try(:nickname) || reply.to_user.try(:hack_mobile)
    end
    column :content, sortable: false
    column :created_at
    actions
  end


end
