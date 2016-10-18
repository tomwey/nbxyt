module API
  module V1
    class MessagesAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :messages, desc: "消息相关接口" do 
        desc "获取所有未读的消息总数"
        params do
          requires :token,   type: String, desc: "用户Token"
        end
        get :unread_count do
          user = authenticate!
          
          session_ids = MessageSession.where('sponsor_id = :user_id or actor_id = :user_id', user_id: user.id).pluck(:id)
          unread_msg_count = Message.where(message_session_id: session_ids, unread: true, recipient_id: user.id).count
          
          unread_notification_count = 0
          
          { count: unread_msg_count + unread_notification_count }
        end # end get
        
        desc "发消息"
        params do
          requires :token,   type: String, desc: "用户Token"
          requires :content, type: String, desc: "消息内容"
          requires :to,      type: String, desc: "消息接收者UID"
        end
        post :send do
          sender = authenticate!
          
          receiver = User.find_by(uid: params[:to])
          if receiver.blank?
            return render_error(4004, '接收者不存在')
          end
          
          if sender.id == receiver.id
            return render_error(-2, '不能给自己发消息')
          end
          
          message_session = MessageSession.session_for(sender.id, receiver.id)
          if message_session.blank?
            message_session = MessageSession.create!(sponsor_id: sender.id, actor_id: receiver.id);
          end
          
          message = message_session.messages.create!(content: params[:content], sender_id: sender.id, recipient_id: receiver.id)
          
          render_json(message, API::V1::Entities::Message, { user: sender })
        end # end post message
        
        desc "获取用户所有的会话，支持分页"
        params do
          requires :token, type: String, desc: '用户Token'
          use :pagination
        end
        get :sessions do
          user = authenticate!
          
          message_sessions = MessageSession.where('sponsor_id = :user_id or actor_id = :user_id', user_id: user.id).order('updated_at desc')
          render_json(message_sessions, API::V1::Entities::MessageSession, { user: user })
        end # end get
        
        desc "获取某个session下面的所有消息"
        params do
          requires :token, type: String, desc: '用户Token'
          requires :to,    type: String, desc: '消息接收方UID'
          optional :need_sort,  type: Integer, desc: '是否需要服务器排序，值为0或1,0表示不需要排序，1表示需要排序, 默认为0'
          use :pagination
        end
        get do
          user = authenticate!
          
          to_user = User.find_by(uid: params[:to])
          if to_user.blank?
            return render_error(4004, '消息接收者不存在')
          end
          
          message_session = MessageSession.session_for(user.id, to_user.id)
          if message_session.blank?
            return render_error(-5, '消息会话不存在')
          end
          
          if params[:page].blank? or params[:page].to_i <= 1
            # 初次加载的时候，标记所有未读消息为已读
            Message.where(message_session_id: message_session.id, unread: true, recipient_id: user.id).update_all(unread: false)
          end
          
          @messages = message_session.messages.order('id desc')
          
          total = @messages.size
          if params[:page]
            @messages = @messages.paginate page: params[:page], per_page: page_size
            total = @messages.total_entries
          end
          
          # 倒序
          need_sort = (params[:need_sort] || 0).to_i
          unless need_sort == 0
            @messages = @messages.to_a
            @messages.reverse!
          end
          
          render_json(@messages, API::V1::Entities::Message, { user: user }, total)
        end # end get
        
      end # end resource
      
    end
  end
end