require 'active_admin/helpers/collection'
# 重写activeadmin的render_blank_slate方法，去掉数据为空时的新建连接
module ActiveAdmin
  module Views
    module Pages
      class Index < Base
        protected
        def render_blank_slate
          blank_slate_content = I18n.t("active_admin.blank_slate.content", resource_name: active_admin_config.plural_resource_label)
          insert_tag(view_factory.blank_slate, blank_slate_content)
        end
      end
    end
  end
end