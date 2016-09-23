module API
  module V1
    class AttendsAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :attends, desc: '参加活动接口' do
        desc "新建一条报名信息"
        params do
          requires :token,    type: String,  desc: "用户认证Token"
          requires :event_id, type: Integer, desc: "活动ID"
        end
        post do
          user = authenticate!
          
          event = Event.find_by(id: params[:event_id])
          
          return render_error(4004, '未找到活动') if event.blank?
          
          return render_error(5001, '你已经报名了该活动') if user.has_attended?(event)
          
          Attend.create!(user_id: user.id, event_id: event.id)
          
          render_json_no_data
        end # end post
        
      end # end resource
      
    end
  end
end