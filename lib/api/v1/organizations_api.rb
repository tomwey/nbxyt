module API
  module V1
    class OrganizationsAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :organizations, desc: '校友组织相关接口' do
        desc "获取校友总会信息"
        get :assoc do
          @organ = Organization.find_by(name: '校友总会')
          return render_error(4004, '未找到校友总会') if @organ.blank?
          
          render_json(@organ, API::V1::Entities::OrganizationAssoc)
        end # end get
        
        desc "获取校友总会详情"
        get '/assoc/body' do
          @organ = Organization.find_by(name: '校友总会')
          return render_error(4004, '未找到校友总会') if @organ.blank?
          
          render_json(@organ, API::V1::Entities::OrganizationAssocDetail)
        end # end get
        
        desc "获取校友组织信息"
        get do
          @organs = Organization.where.not(name: '校友总会').sorted
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
        
        desc "获取所有的成员"
        params do
          requires :id, type: Integer, desc: '校友会组织ID'
          use :pagination
        end
        get '/:id/users' do
          @organ = Organization.find_by(id: params[:id])
          
          if @organ.blank?
            return render_error(4004, '没有该记录')
          end
          
          @users = @organ.users.order('relationships.id desc')
          
          if params[:page]
            @users = @users.paginate page: params[:page], per_page: page_size
          end
          
          render_json(@users, API::V1::Entities::UserProfile)
        end # end get
        
        desc "加入校友会"
        params do
          requires :token, type: String, desc: '用户认证Token'
          requires :organization_id, type: Integer, desc: '校友会ID'
        end
        post :join do
          user = authenticate!
          
          @organization = Organization.find_by(id: params[:organization_id])
          
          if @organization.blank?
            return render_error(4004, '未找到该校友会')
          end
          
          if user.join!(@organization)
            render_json_no_data
          else
            render_error(5001, '加入校友会失败')
          end
        end # end post
        
      end # end resource
      
    end
  end
end