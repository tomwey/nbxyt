module API
  module V1
    class PracticeBasesAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :bases, desc: '实习基地相关接口' do
        desc '获取实习基地列表'
        params do
          use :pagination
        end
        get do
          @bases = PracticeBase.order('sort desc, id desc')
          if params[:page]
            @bases = @bases.paginate page: params[:page], per_page: page_size
          end
          
          render_json(@bases, API::V1::Entities::PracticeBase)
        end # end get
        
        desc '获取实习基地详情'
        params do
          requires :id, type: Integer, desc: '基地ID'
          optional :token, type: String, desc: '用户认证TOKEN'
        end
        get '/:id' do
          @base = PracticeBase.find_by(id: params[:id])
          
          if @base.blank?
            return render_error(4004, '未找到基地')
          end
          
          user = User.find_by(private_token: params[:token])
          
          render_json(@base, API::V1::Entities::PracticeBaseDetail, { user: user })
          
        end
        
      end # end resource
      
    end
  end
end