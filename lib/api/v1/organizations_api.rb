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
          requires :id,    type: Integer, desc: '校友组织ID'
          optional :token, type: String,  desc: '用户Token'
        end
        get '/:id' do
          @organ = Organization.includes(:users, :events).find_by(id: params[:id])
          if @organ.blank?
            return render_error(4004, '没有该记录')
          end
          
          user = User.find_by(private_token: params[:token])
          
          render_json(@organ, API::V1::Entities::OrganizationDetail, { user: user })
        end # end get detail
        
      end # end resource
      
    end
  end
end