module API
  module V1
    class ClubsAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :clubs, desc: '校友俱乐部相关接口' do
        desc "获取俱乐部列表"
        params do
          use :pagination
        end
        get do
          @clubs = Club.order('sort desc, id desc')
          if params[:page]
            @clubs = @clubs.paginate page: params[:page], per_page: page_size
          end
          
          render_json(@clubs, API::V1::Entities::Club)
        end # end get
        
        desc "获取俱乐部详情"
        params do
          requires :id, type: Integer, desc: '俱乐部ID'
          optional :token, type: String, desc: '用户认证Token'
        end
        get '/:id' do
          @club = Club.find_by(id: params[:id])
          
          if @club.blank?
            return render_error(4004, '未找到该俱乐部')
          end
          
          user = User.find_by(private_token: params[:token])
          render_json(@club, API::V1::Entities::ClubDetail, { user: user })
        end # end get
        
        desc "获取俱乐部章程"
        params do
          requires :id, type: Integer, desc: '俱乐部ID'
        end
        get '/:id/bylaw' do
          @club = Club.find_by(id: params[:id])
          
          if @club.blank?
            return render_error(4004, '未找到该俱乐部')
          end
          
          render_json(@club, API::V1::Entities::ClubDetail2)
        end # end get
        
        desc "加入俱乐部"
        params do
          requires :token, type: String, desc: '用户认证Token'
          requires :club_id, type: Integer, desc: '俱乐部ID'
        end
        post :join do
          user = authenticate!
          
          @club = Club.find_by(id: params[:club_id])
          
          if @club.blank?
            return render_error(4004, '未找到该俱乐部')
          end
          
          if user.join!(@club)
            render_json_no_data
          else
            render_error(5001, '加入俱乐部失败')
          end
        end # end post
        
      end # end resource
      
    end
  end
end