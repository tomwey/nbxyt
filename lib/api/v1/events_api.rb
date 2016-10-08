module API
  module V1
    class EventsAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :events, desc: '活动接口' do
        desc "获取活动列表"
        params do
          optional :eventable_type, type: String, desc: "所属类型，可能的值为：Organization, Club, PracticeBase"
          optional :eventable_id,   type: Integer, desc: "所属的具体类型ID"
          use :pagination
        end
        get do
          @events = Event.order('sort desc, started_at desc')
          
          if params[:eventable_id]
            if params[:eventable_type].blank?
              return render_error(-1, '需要eventable_type参数')
            end
            @events = @events.where(eventable_type: params[:eventable_type], eventable_id: params[:eventable_id])
          else
            @events = @events.where(eventable_type: params[:eventable_type])
          end
          
          if params[:page]
            @events = @events.paginate page: params[:page], per_page: page_size
          end
          
          render_json(@events, API::V1::Entities::Event)
        end #end get 
        
        desc "获取活动详情"
        params do 
          optional :token,    type: String, desc: "用户Token"
          requires :id, type: Integer, desc: '活动ID'
        end
        get '/:id' do
          @event = Event.find_by(id: params[:id])
          
          return render_error(4004, '未找到活动') if @event.blank?
          
          user = User.find_by(private_token: params[:token])
          
          render_json(@event, API::V1::Entities::EventDetail, { user: user })
        end # end get /events/123
      end # end resource
      
    end
  end
end