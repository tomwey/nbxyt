module API
  module V1
    class RelationshipsAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :relationships, desc: '加入校友会、俱乐部相关接口' do
        desc "加入校友会"
        params do 
          requires :token, type: String, desc: '用户Token'
          requires :id,    type: Integer, desc: '某个校友会ID'
        end
        post '/organization/join' do
          user = authenticate!
          
          organ = Organization.find_by(id: params[:id])
          return render_error(4004, '不存在的校友会') if organ.blank?
          
          return render_error(3001, '你已经加入了该校友会，不能重复加入') if user.has_joined?(organ)
          
          if user.join!(organ)
            render_json_no_data
          else
            render_error(3002, '加入失败')
          end
        end # end post
        
        desc "取消加入校友会"
        params do 
          requires :token, type: String, desc: '用户Token'
          requires :id,    type: Integer, desc: '某个校友会ID'
        end
        post '/organization/cancel_join' do
          user = authenticate!
          
          organ = Organization.find_by(id: params[:id])
          return render_error(4004, '不存在的校友会') if organ.blank?
          
          return render_error(3001, '你还未加入该校友会，不能取消') unless user.has_joined?(organ)
          
          if user.cancel_join!(organ)
            render_json_no_data
          else
            render_error(3002, '取消加入失败')
          end
          
        end # end post
        
        desc "加入俱乐部"
        params do 
          requires :token, type: String, desc: '用户Token'
          requires :id,    type: Integer, desc: '某个校友俱乐部ID'
        end
        post '/club/join' do
          user = authenticate!
          
          club = Club.find_by(id: params[:id])
          return render_error(4004, '不存在的校友俱乐部') if club.blank?
          
          return render_error(3001, '你已经加入了该校友俱乐部，不能重复加入') if user.has_joined?(club)
          
          if user.join!(club)
            render_json_no_data
          else
            render_error(3002, '加入失败')
          end
        end # end post
        
        desc "取消加入校友俱乐部"
        params do 
          requires :token, type: String, desc: '用户Token'
          requires :id,    type: Integer, desc: '某个校友俱乐部ID'
        end
        post '/club/cancel_join' do
          user = authenticate!
          
          club = Club.find_by(id: params[:id])
          return render_error(4004, '不存在的校友俱乐部') if club.blank?
          
          return render_error(3001, '你还未加入该校友俱乐部，不能取消') unless user.has_joined?(club)
          
          if user.cancel_join!(club)
            render_json_no_data
          else
            render_error(3002, '取消加入失败')
          end
          
        end # end post
        
      end # end resource
      
    end
  end
end