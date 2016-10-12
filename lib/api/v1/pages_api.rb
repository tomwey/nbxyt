module API
  module V1
    class PagesAPI < Grape::API
      resource :pages, desc: '文档相关接口' do 
        desc "获取一篇指定slug的文章"
        params do
          requires :slug, type: String, desc: '文档标识'
        end
        get '/:slug' do
          @page = Page.find_by(slug: params[:slug])
          
          return render_error(4004, '未找到文档') if @page.blank?
          
          render_json(@page, API::V1::Entities::Page)
        end # end get
      end # end resource
    end
  end
end