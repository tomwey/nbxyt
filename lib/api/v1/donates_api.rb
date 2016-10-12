module API
  module V1
    class DonatesAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :donates, desc: '捐赠相关接口' do
        desc "获取捐赠首页数据"
        get :home do
          result = {}
          
          @donates = Donate.order('donated_on desc, id desc').limit(5)
          if @donates.any?
            result[:donates] = { data: @donates.as_json, has_more: @donates.size > 5 }
          end
          
          @node = Node.find_by(name: '相关报道')
          if @node
            @articles_1 = Article.where(node_id: @node.id).order('published_at desc, id desc').limit(5)
            if @articles_1.any?
              result[:reports] = { data: @articles_1.as_json, has_more: @articles_1.size > 5 }
            end
          end
          
          @node2 = Node.find_by(name: '捐赠感谢')
          if @node2
            @articles_2 = Article.where(node_id: @node2.id).order('published_at desc, id desc').limit(5)
            if @articles_2.any?
              result[:thanks] = { data: @articles_2.as_json, has_more: @articles_2.size > 5 }
            end
          end
          
          { code: 0, message: 'ok', data: result }
        end # end get home
        
        desc "获取捐赠列表"
        params do
          use :pagination
        end
        get do
          @donates = Donate.order('donated_on desc, id desc')
          if params[:page]
            @donates = @donates.paginate page: params[:page], per_page: page_size
          end
          render_json(@donates, API::V1::Entities::Donate)
        end # end get list
        
        desc "获取捐赠详情"
        params do
          requires :id, type: Integer, desc: '捐赠ID'
        end
        get '/:id' do
          @donate = Donate.find_by(id: params[:id])
          
          return render_error(4004, '没有该捐赠信息') if @donate.blank?
          
          render_json(@donate, API::V1::Entities::DonateDetail)
        end # end /:id
        
        desc "提交捐赠意向"
        params do
          requires :content, type: String, desc: '捐赠介绍'
          requires :contact, type: String, desc: '联系方式'
        end
        post :apply do
          DonateApply.create!(content: params[:content], contact: params[:contact])
          
          render_json_no_data
        end # end post
        
      end # end resource
      
      resource :articles, desc: '捐赠文章相关接口' do 
        desc "获取捐赠文章列表"
        params do
          requires :type_id, type: Integer, desc: '文章类别ID'
          use :pagination
        end
        get '/type:type_id' do
          @type = Node.find_by(id: params[:type_id])
          
          return render_error(4004, '没有该类别') if @type.blank?
          
          @articles = Article.where(node_id: @type.id).order('published_at desc, id desc')
          if params[:page]
            @articles = @articles.paginate page: params[:page], per_page: page_size
          end
          
          render_json(@articles, API::V1::Entities::Article)
        end # end get
        
        desc "获取文章详情"
        params do
          requires :id, type: Integer, desc: '文章ID'
        end
        get '/:id' do
          @article = Article.find_by(id: params[:id])
          
          return render_error(4004, '没有该类别') if @article.blank?
          
          render_json(@article, API::V1::Entities::ArticleDetail)
        end # end get
      end # end resource
      
    end
  end
end