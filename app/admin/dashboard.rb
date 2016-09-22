ActiveAdmin.register_page "Dashboard" do

  menu priority: 0, label: proc{ I18n.t("active_admin.dashboard") }

  content title: '最新数据统计' do
    
    # 最新用户
    columns do
      column do
        panel "最新用户" do
          table_for User.order('id desc').limit(20) do
            column :id
            column :avatar, sortable: false do |u|
              u.avatar.blank? ? "" : image_tag(u.avatar.url(:normal))
            end
            column :uid, sortable: false
            column :nickname, sortable: false
            column :mobile, sortable: false
            column 'Token', sortable: false do |u|
              u.private_token
            end
            column :verified, sortable: false
            column :created_at
          end
        end
      end # end 
    end
    
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
