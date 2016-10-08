module API
  module V1
    class BannersAPI < Grape::API
      
      resource :banners, desc: "首页Banner接口" do
        desc "获取广告列表"
        params do
          optional :size, type: Integer, desc: '滚动信息的数量，默认为5'
        end
        get do
          
          result = []
          
          size = (params[:size] || 5).to_i
          @events = Event.order('sort desc, id desc').limit(3)
          count = size - @events.size
          
          # 组装活动数据
          if @events.any?
            @events.each do |event|
              result << {
                title: event.title,
                image: event.image.blank? ? '' : event.image.url(:large),
                bannerable_type: 'event',
                bannerable_id: event.id,
              }
            end
          end
          
          @node = Node.find_by(name: '首页文章')
          
          if @node
            @articles = Article.where(node_id: @node.id).order('id desc').limit(count)
            
            # 组装首页文章数据
            @articles.each do |article|
              result << {
                title: article.title,
                image: article.image.blank? ? '' : article.image.url(:large),
                bannerable_type: 'article',
                bannerable_id: article.id,
              }
            end
          end
          
          { code: 0, message: 'ok', data: result }
          
        end # end get
        
        # desc '获取广告列表'
        # params do
        #   optional :size,  type: Integer, desc: '获取的广告条数'
        # end
        # get do
        #   size = params[:size].blank? ? 5 : params[:size].to_i 
        #   @banners = Banner.sorted.recent.limit(size)
        #   render_json(@banners, API::V1::Entities::Banner)
        # end
        # 
        # desc '获取某个视频类别下面的广告'
        # params do
        #   requires :cid, type: Integer, desc: '类别ID'
        # end
        # get '/category/:category_id' do
        #   @banners = Banner.where(category_id: params[:category_id]).sorted.recent
        #   render_json(@banners, API::V1::Entities::Banner)
        # end
        
      end # end resource
      
    end
  end
end