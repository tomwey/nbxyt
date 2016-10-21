module API
  module V1
    class UsersAPI < Grape::API
      
      helpers API::SharedParams
      
      # 学校信息
      resource :college, desc: '大学学科信息接口' do
        desc "获取院系、专业"
        get :specialties do
          @faculties = Faculty.order('sort desc, id desc')
          render_json(@faculties, API::V1::Entities::Faculty)
        end # end get
        
        desc "获取年级信息"
        get :graduations do
          @graduations = Graduation.order('name asc')
          render_json(@graduations, API::V1::Entities::Graduation)
        end # end get
      end # end resource
      
      # 用户账号管理
      resource :account, desc: "注册登录接口" do
        
        desc "用户注册"
        params do
          requires :mobile,   type: String, desc: "用户手机号"
          requires :password, type: String, desc: "密码"
          requires :code,     type: String, desc: "手机验证码"
          optional :realname, type: String, desc: "真实姓名"
          optional :faculty_id, type: Integer, desc: "院系ID"
          optional :specialty_id, type: Integer, desc: "专业ID"
          optional :graduation_id, type: Integer, desc: "班级ID"
          optional :stu_no, type: String, desc: "学号"
        end
        post :signup do
          # 手机号检查
          return render_error(1001, '不正确的手机号') unless check_mobile(params[:mobile])
          
          # 是否已经注册检查
          user = User.find_by(mobile: params[:mobile])
          return render_error(1002, "#{params[:mobile]}已经注册") unless user.blank?
          
          # 密码长度检查
          return render_error(1003, "密码太短，至少为6位") unless params[:password].length >= 6
          
          # 检查验证码是否有效
          auth_code = AuthCode.check_code_for(params[:mobile], params[:code])
          return render_error(2004, '验证码无效') if auth_code.blank?
          
          # 注册
          user = User.create!(mobile: params[:mobile], password: params[:password], password_confirmation: params[:password],
          realname: params[:realname], faculty_id: params[:faculty_id], specialty_id: params[:specialty_id], graduation_id: params[:graduation_id], stu_no: params[:stu_no])
          
          # 激活当前验证码
          auth_code.update_attribute(:activated_at, Time.now)
          
          # 返回注册成功的用户
          render_json(user, API::V1::Entities::User)
        end # end post signup
        
        desc "用户登录"
        params do
          requires :mobile,   type: String, desc: "用户手机号，必须"
          requires :password, type: String, desc: "密码，必须"
        end
        post :login do
          # 手机号检测
          return render_error(1001, "不正确的手机号") unless check_mobile(params[:mobile])
          
          # 登录
          user = User.find_by(mobile: params[:mobile])
          return render_error(1004, "用户#{params[:mobile]}未注册") if user.blank?
          
          if user.authenticate(params[:password])
            render_json(user, API::V1::Entities::User)
          else
            render_error(1005, "登录密码不正确")
          end
        end # end post login
        
        desc "完善资料"
        params do
          requires :token, type: String, desc: "用户Token"
          requires :realname, type: String, desc: "真实姓名"
          optional :stu_no, type: String, desc: "学号"
          requires :faculty_id, type: Integer, desc: "所在院系ID"
          requires :specialty_id, type: Integer, desc: "专业ID"
          requires :graduation_id, type: Integer, desc: "年级ID"
        end
        post :update_profile do
          user = authenticate!
          
          user.realname = params[:realname]
          user.stu_no = params[:stu_no]
          user.faculty_id = params[:faculty_id]
          user.specialty_id = params[:specialty_id]
          user.graduation_id = params[:graduation_id]
          
          if user.save!
            render_json(user, API::V1::Entities::UserProfile)
          else
            render_error(1009, '完善资料失败')
          end
          
        end # end post
        
      end # end account resource
      
      resource :user, desc: "用户接口" do
        
        # desc "公开的认证接口"
        # params do
        #   requires :mobile,   type: String, desc: "手机号"
        #   requires :password, type: String, desc: "密码"
        #   optional :mac_addr, type: String, desc: "MAC地址"
        # end
        # get :auth do
        #   # 手机号检测
        #   return render_error(1001, "不正确的手机号") unless check_mobile(params[:mobile])
        #
        #   # 登录
        #   user = User.find_by(mobile: params[:mobile])
        #   return render_error(1004, "用户#{params[:mobile]}未注册") if user.blank?
        #
        #   if user.authenticate(params[:password])
        #     user.update_attribute(:mac_addr, params[:mac_addr]) if user.mac_addr.blank?
        #     render_json(user, API::V1::Entities::User)
        #   else
        #     render_error(1005, "登录密码不正确")
        #   end
        # end # end get auth
        
        desc "获取加入的校友组织"
        params do
          requires :token, type: String, desc: '用户Token'
          use :pagination
        end
        get :organizations do
          user = authenticate!
          
          @organs = user.organizations.order('relationships.id desc, sort desc, id desc')
          
          if params[:page]
            @organs = @organs.paginate page: params[:page], per_page: page_size
          end
          
          render_json(@organs, API::V1::Entities::Organization)
        end # end get
        
        desc "获取加入的俱乐部"
        params do
          requires :token, type: String, desc: '用户Token'
          use :pagination
        end
        get :clubs do
          user = authenticate!
          
          @clubs = user.clubs.order('relationships.id desc, sort desc, id desc')
          
          if params[:page]
            @clubs = @clubs.paginate page: params[:page], per_page: page_size
          end
          
          render_json(@clubs, API::V1::Entities::Club)
        end # end get
        
        desc "获取参加的活动"
        params do
          requires :token, type: String, desc: '用户Token'
          use :pagination
        end
        get :events do
          user = authenticate!
          
          @events = user.events.order('attends.id desc, started_at desc')
          
          if params[:page]
            @events = @events.paginate page: params[:page], per_page: page_size
          end
          
          render_json(@events, API::V1::Entities::Event)
        end # end get
        
        desc "获取个人资料"
        params do
          requires :token, type: String, desc: "用户认证Token"
        end
        get :me do
          user = authenticate!
          render_json(user, API::V1::Entities::User)
        end # end get me
        
        desc "修改头像"
        params do
          requires :token,  type: String, desc: "用户认证Token, 必须"
          requires :avatar, type: Rack::Multipart::UploadedFile, desc: "用户头像"
        end
        post :update_avatar do
          user = authenticate!
          
          if params[:avatar]
            user.avatar = params[:avatar]
          end
          
          if user.save
            render_json(user, API::V1::Entities::User)
          else
            render_error(1006, user.errors.full_messages.join(","))
          end
        end # end update_avatar
        
        desc "修改头像，上传的图片经过base64编码"
        params do
          requires :token,  type: String, desc: "用户认证Token, 必须"
          requires :avatar, type: String, desc: "头像图片base64编码字符串"
        end
        post :update_base64_avatar do
          user = authenticate!
          
          if params[:avatar]
            user.avatar = decode_base64_image(params[:avatar])
          end
          
          if user.save
            render_json(user, API::V1::Entities::User)
          else
            render_error(1006, user.errors.full_messages.join(","))
          end
        end # end update_avatar
        
        desc "修改昵称"
        params do
          requires :token,    type: String, desc: "用户认证Token, 必须"
          requires :nickname, type: String, desc: "用户昵称"
        end
        post :update_nickname do
          user = authenticate!
          
          if params[:nickname]
            user.nickname = params[:nickname]
          end
          
          if user.save
            render_json(user, API::V1::Entities::User)
          else
            render_error(1006, user.errors.full_messages.join(","))
          end
        end # end update nickname
        
        desc "修改手机号"
        params do
          requires :token,  type: String, desc: "用户认证Token, 必须"
          requires :mobile, type: String, desc: "新手机号，必须"
          requires :code,   type: String, desc: "新手机号收到的验证码"
        end
        post :update_mobile do
          user = authenticate!
          
          # 手机号检测
          return render_error(1001, "不正确的手机号") unless check_mobile(params[:mobile])
          
          # 是否已经注册检查
          new_user = User.find_by(mobile: params[:mobile])
          return render_error(1002, "#{params[:mobile]}已经存在，请换一个手机号") unless new_user.blank?
          
          # 检查验证码是否有效
          auth_code = AuthCode.check_code_for(params[:mobile], params[:code])
          return render_error(2004, '验证码无效') if auth_code.blank?
          
          user.mobile = params[:mobile]
          if user.save
            # 激活当前验证码
            auth_code.update_attribute(:activated_at, Time.now)
            
            render_json(user, API::V1::Entities::User)
          else
            render_error(1009, '更新手机号失败！')
          end
          
        end # end post
        
        desc "修改密码"
        params do
          # requires :token,    type: String, desc: "用户认证Token, 必须"
          optional :token, type: String,    desc: "用户认证Token"
          requires :password, type: String, desc: "新的密码，必须"
          requires :code,     type: String, desc: "手机验证码，必须"
          requires :mobile,   type: String, desc: "手机号，必须"
        end
        post :update_password do
          
          if params[:token]
            user = authenticate!
            if user.mobile != params[:mobile]
              return render_error(-1, '不是同一个用户，非法操作')
            end
          else
            user = User.find_by(mobile: params[:mobile])
            return render_error(1004, '用户还未注册') if user.blank?
          end
          
          # 检查密码长度
          return render_error(1003, '密码太短，至少为6位') if params[:password].length < 6
          
          # 检查验证码是否有效
          auth_code = AuthCode.check_code_for(user.mobile, params[:code])
          return render_error(2004, '验证码无效') if auth_code.blank?
          
          # 更新密码
          user.password = params[:password]
          user.password_confirmation = user.password
          user.save!
          
          # 激活当前验证码
          auth_code.update_attribute(:activated_at, Time.now)
          
          render_json_no_data
        end # end update password
        
        desc "更新支付密码"
        params do
          requires :token,        type: String, desc: "用户认证Token, 必须"
          requires :code,         type: String, desc: "手机验证码，必须"
          requires :pay_password, type: String, desc: "支付密码，必须"
        end
        post :update_pay_password do
          user = authenticate!
          
          # 检查验证码是否有效
          auth_code = AuthCode.check_code_for(user.mobile, params[:code])
          return render_error(2004, '验证码无效') if auth_code.blank?
          
          # 检查密码长度
          return render_error(1003, '密码太短，至少为6位') if params[:pay_password].length < 6
          
          if user.update_pay_password!(params[:pay_password])
            # 激活当前验证码
            auth_code.update_attribute(:activated_at, Time.now)
            
            render_json_no_data
          else
            render_error(3003, "设置支付密码失败")
          end
          
        end # end update pay_password
        
      end # end user resource
      
      # 同学录相关接口
      resource :users, desc: '同学录相关接口' do
        desc "获取校友信息支持搜索功能"
        params do
          optional :token, type: String, desc: '用户认证Token'
          optional :q,     type: String, desc: '关键字'
          optional :owner_type, type: String, desc: '所有者类型，值为Club或者Organization'
          optional :owner_id,   type: Integer, desc: '所有者对象ID'
          use :pagination
        end
        get do
          if params[:owner_type] && params[:owner_id]
            klass = params[:owner_type].classify.constantize
            @owner = klass.find_by(id: params[:owner_id])
            if @owner.blank?
              return render_error(4004, '未找到对象')
            end
            @users = @owner.users.order('relationships.id desc')
          else
            @users = User.order('id desc')
          end
          
          # 去掉自己
          if params[:token]
            user = User.find_by(private_token: params[:token])
          else
            user = nil
          end
          if user
            @users = @users.where.not(id: user.id)
          end
          
          if params[:q] && params[:q].strip
            @users = @users.joins(:faculty, :specialty, :graduation).where("nickname like :q or realname like :q or mobile like :q or faculties.name like :q or specialties.name like :q or graduations.name like :q", q: "%#{params[:q].strip}%")
          end
          
          total = @users.size
          if params[:page]
            @users = @users.paginate page: params[:page], per_page: page_size
            total = @users.total_entries;
          end
          
          render_json(@users, API::V1::Entities::SimpleUser2, total)
        end # end
        
        desc "获取校友详情"
        params do
          requires :token, type: String, desc: '用户认证Token'
          requires :uid,   type: String, desc: '用户UID'
        end
        get '/:uid' do
          authenticate!
          
          # 身份确认
          need_valid!
          
          @user = User.find_by(uid: params[:uid])
          
          if @user.blank?
            return render_error(4004, '未找到该校友')
          end
          
          render_json(@user, API::V1::Entities::UserProfile)
        end
      end # end resource
      
    end 
  end
end