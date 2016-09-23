module API
  module V1
    class EventsAPI < Grape::API
      
      resource :events, desc: '活动接口' do
        desc "获取活动详情"
        params do 
          optional :token,    type: String, desc: "用户Token"
          requires :event_id, type: Integer, desc: '活动ID'
        end
        get :event_id do
          @event = Event.find_by(id: params[:event_id])
          
          return render_error(4004, '未找到活动') if @event.blank?
          
          user = User.find_by(private_token: params[:token])
          
          render_json(@event, API::V1::Entities::Event, { user: user })
        end # end get /events/123
      end # end resource
      
    end
  end
end