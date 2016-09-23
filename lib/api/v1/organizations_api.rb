module API
  module V1
    class OrganizationsAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :organizations, desc: '校友组织相关接口' do
        desc "获取校友组织信息"
        get do
          @organs = Organization.sorted
          render_json(@organs, API::V1::Entities::Organization)
        end # end get
        
        desc "获取某个校友组织的详细信息"
        params do
          requires :id, type: Integer, desc: '校友组织ID'
        end
        get '/:id' do
          @organ = Organization.includes(:users, :events).find_by(id: params[:id])
          if @organ.blank?
            return render_error(4004, '没有该记录')
          end
          
          render_json(@organ, API::V1::Entities::OrganizationDetail)
        end # end get detail
        
        desc "加入校友组织"
        params do
          requires :token, type: String,  desc: '用户Token'
          requires :oid,   type: Integer, desc: '校友组织ID'
        end
        post :join do
          user = authenticate!
          
          organ = Organization.find_by(id: params[:oid])
          if organ.blank?
            return render_error(4004, '没有找到校友组织')
          end
          
          if user.joined_organization?(organ)
            return render_error(3001, '您已经加入过该校友组织，不能重复加入')
          end
          
          if user.join_organization(organ)
            render_json_no_data
          else
            render_error(3002, '加入校友组织失败')
          end
        end # end post
        
        desc "取消加入校友组织"
        params do
          requires :token, type: String,  desc: '用户Token'
          requires :oid,   type: Integer, desc: '校友组织ID'
        end
        post :cancel_join do
          user = authenticate!
          
          organ = Organization.find_by(id: params[:oid])
          if organ.blank?
            return render_error(4004, '没有找到校友组织')
          end
          
          unless user.joined_organization?(organ)
            return render_error(3001, '您还未加入该校友组织，不能取消')
          end
          
          if user.cancel_join_organization(organ)
            render_json_no_data
          else
            render_error(3002, '取消加入校友组织失败')
          end
        end # end post
        
      end # end resource
      
    end
  end
end