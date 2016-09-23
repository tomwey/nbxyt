module API
  module V1
    class RepliesAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :replies, desc: '留言相关接口' do
        desc "获取最近的留言"
        params do
          optional :model, type: String, values: %w(Organization Club Mentor), desc: '留言所属的版块名字，值为Organization（校友）, Club（俱乐部）, Mentor（导师）；如果不传该参数表示获取所有的留言'
          optional :id, type: Integer, desc: '某个版块的ID，只有获取某个具体版本下面的留言才传该参数'
          optional :size, type: Integer, desc: '获取最新的留言数量，不传该参数默认为5条记录'
        end
        get :latest do
          size = (params[:size] || 5).to_i
          @replies = Reply.latest.limit(size)
          if params[:model]
            @replies = @replies.where(replyable_type: params[:model])
          end
          
          if params[:id]
            @replies = @replies.where(replyable_id: params[:id])
          end
          
          render_json(@replies, API::V1::Entities::Reply)
        end # end get latest
        
        desc "分页获取所有的留言"
        params do
          optional :model, type: String, values: %w(Organization Club Mentor), desc: '留言所属的版块名字，值为Organization（校友）, Club（俱乐部）, Mentor（导师）；如果不传该参数表示获取所有的留言'
          optional :id, type: Integer, desc: '某个版块的ID，只有获取某个具体版本下面的留言才传该参数'
          use :pagination
        end
        get :list do
          @replies = Reply.latest
          if params[:model]
            @replies = @replies.where(replyable_type: params[:model])
          end
          
          if params[:id]
            @replies = @replies.where(replyable_id: params[:id])
          end
          
          if params[:page]
            @replies = @replies.paginate page: params[:page], per_page: page_size
            total = @replies.total_entries
          else
            total = @replies.size
          end
          
          render_json(@replies, API::V1::Entities::Reply, total)
        end # end get list
        
        desc "发布留言"
        params do
          requires :token, type: String, desc: '用户Token'
          requires :model, type: String, values: %w(Organization Club Mentor), desc: '留言所属的版块名字，值为Organization（校友）, Club（俱乐部）, Mentor（导师）'
          requires :id,    type: Integer, desc: '某个模块的ID'
          requires :content, type: String, desc: '留言内容'
          optional :to,    type: String,  desc: '接收者用户的UID'
        end
        post :create do
          user = authenticate!
          
          to = User.find_by(uid: params[:to])
          
          klass = params[:model].classify.constantize
          replyable = klass.find_by(id: params[:id])
          
          return render_error(4004, '未找到模块') if replyable.blank?
          
          @reply = Reply.create!(sender: user.id, receiver: to.id, replyable: replyable, content: params[:content])
          render_json(@reply, API::V1::Entities::Reply)
        end # end post
      end # end resource
      
    end
  end
end