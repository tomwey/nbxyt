module API
  module V1
    module Entities
      class Base < Grape::Entity
        format_with(:null) { |v| v.blank? ? "" : v }
        format_with(:chinese_date) { |v| v.blank? ? "" : v.strftime('%Y-%m-%d') }
        format_with(:chinese_datetime) { |v| v.blank? ? "" : v.strftime('%Y-%m-%d %H:%M:%S') }
        format_with(:money_format) { |v| v.blank? ? 0 : ('%.2f' % v).to_f }
        expose :id
        # expose :created_at, format_with: :chinese_datetime
      end # end Base
      
      # 收货地址
      class Shipment < Base
        expose :name
        expose :hack_mobile, as: :mobile
        expose :address
        expose :is_current do |model, opts|
          model.id == model.user.try(:current_shipment_id)
        end
      end
      
      # 用户基本信息
      class UserProfile < Base
        expose :uid, format_with: :null
        expose :mobile, format_with: :null
        expose :nickname do |model, opts|
          model.nickname || model.hack_mobile
        end
        expose :avatar do |model, opts|
          model.avatar.blank? ? "" : model.avatar_url(:large)
        end
        expose :realname, format_with: :null
        expose :stu_no, format_with: :null
        expose :faculty do |model, opts|
          model.faculty.try(:name) || ''
        end
        expose :specialty do |model, opts|
          model.specialty.try(:name) || ''
        end
        expose :graduation do |model, opts|
          model.graduation.try(:name) || ''
        end
      end
      
      # 用户详情
      class User < UserProfile
        expose :private_token, as: :token, format_with: :null
      end
      
      # 活动
      class Event < Base
        expose :title
        expose :image do |model, opts|
          model.image_url(:thumb)
        end
        expose :started_at, format_with: :chinese_datetime
        expose :ended_at, format_with: :chinese_datetime
        expose :total_attends, as: :needed_count
        expose :attends_count, as: :joined_count
        expose :has_attended do |model, opts|
          model.has_attended_for?(opts)
        end
      end
      
      # 校友组织信息
      class Organization < Base
        expose :name, :intro
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:thumb)
        end
        expose :relationships_count, as: :users_count
      end
      
      class OrganizationDetail < Organization
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:large)
        end
        expose :founded_on, format_with: :chinese_date
        expose :body
        expose :has_joined do |model, opts|
          model.has_joined_for?(opts)
        end
        expose :latest_events, using: API::V1::Entities::Event do |model, opts|
          model.events.latest_starting.limit(5)
        end
        expose :latest_users, using: API::V1::Entities::UserProfile do |model, opts|
          model.users.order('relationships.id desc').limit(5)
        end
      end
      
      class Reply < Base
        expose :content
        expose :from_user, using: API::V1::Entities::UserProfile do |model, opts|
          model.from_user
        end
        expose :to_user, using: API::V1::Entities::UserProfile do |model, opts|
          model.to_user
        end
        expose :created_at, as: :time, format_with: :chinese_datetime
      end
      
      # 供应商
      class Merchant < Base
        expose :name
        expose :mobile
        expose :address, format_with: :null
        expose :note, format_with: :null
      end
      
      # 商品
      class Product < Base
        expose :title, :body, :price, :stock, :sku, :is_virtual_goods, :orders_count, :visit_count
        expose :image do |model, opts|
          if model.image.blank?
            ""
          else
            model.image.url(:thumb)
          end
        end
        expose :merchant_name do |model, opts|
          model.merchant.try(:name) || ""
        end
        expose :detail_url
        
      end
      
      # 订单
      class Order < Base
        expose :order_no
        expose :product_title, as: :title
        expose :product_small_image, as: :image
        expose :quantity
        expose :product_price, as: :price
        expose :total_fee
        expose :state_info, as: :state
        expose :created_at, as: :time, format_with: :chinese_datetime
      end
      
      # 收益明细
      class EarnLog < Base
        expose :title
        expose :earn
        expose :unit
        expose :created_at, as: :time, format_with: :chinese_datetime
      end
      
      # 收益摘要
      class EarnSummary < Base
        expose :task_type do |m, opts|
          ::EarnLog::TASK_TYPES.index(m.earnable_type) + 1
        end
        expose :task_name do |m,opts|
          ::EarnLog.task_name(m.earnable_type)
        end
        expose :total
      end
      
      # 积分墙渠道
      class Channel < Base
        expose :name, :title
        expose :subtitle, format_with: :null
        expose :icon do |model, opts|
          if model.icon
            model.icon.url(:large)
          else
            ''
          end
        end
      end
      
      # 关注任务
      class FollowTask < Base
        expose :icon do |model, opts|
          if model.icon
            model.icon.url(:large)
          else
            ''
          end
        end
        expose :gzh_name, :gzh_id
        expose :gzh_intro do |model, opts|
          model.gzh_intro || '7天内不能取消关注'
        end
        expose :earn, as: :income
        expose :link do |model, opts|
          uid = opts[:opts][:uid]
          model.task_detail_url_for(uid)
        end
      end
      
      # 分享任务
      class ShareTask < Base
        expose :icon do |model, opts|
          if model.icon
            model.icon.url(:large)
          else
            ''
          end
        end
        expose :title
        expose :earn, as: :income
        expose :first_open_earn, as: :first_open_income
        expose :link
        expose :left_count do |model, opts|
          [model.quantity - model.visit_count, 0].max
        end
        expose :my_total_income do |model, opts|
          uid = opts[:opts][:uid]
          model.my_total_income_for(uid)
        end
        expose :share_icon do |model, opts|
          if model.icon
            model.icon.url(:large)
          else
            ''
          end
        end
        expose :share_link do |model, opts|
          model.format_share_link_for(opts[:opts][:uid])
        end
        expose :share_content do |model, opts|
          model.format_share_content_for(opts[:opts][:uid])
        end
      end
      
      # 租房
      class Apartment < Base
        expose :images do |model, opts|
          img_size = opts[:opts][:image_size].to_sym
          model.images.map { |img| img.url(img_size) }
        end
        expose :name, :area, :rental, :rent_type
        expose :model do |model, opts|
          model.model_info
        end
        expose :title
        expose :body, format_with: :null
        expose :facilities
        expose :deco_info, format_with: :null
        expose :contact_info, if: proc { |a| not a.hide_mobile } do
          expose :u_name,   format_with: :null
          expose :u_mobile, format_with: :null
        end
        expose :room_info, if: proc { |apartment| apartment.rent_type == '单间' } do
          expose :room_type
          expose :sex_limit
        end
        expose :location_str, as: :location
        expose :distance do |model, opts|
          model.try(:distance) || 0
        end
        expose :published_at
        expose :user, using: API::V1::Entities::UserProfile, if: proc { |a| a.user_id.present? }
      end
      
      # 商家广告
      class AdTask < Base
        expose :title
        expose :subtitle, format_with: :null
        expose :cover_image do |model,opts|
          img_size = opts[:opts][:image_size].to_sym
          if model.cover_image.blank?
            ''
          else
            model.cover_image.url(img_size)
          end
        end
        expose :price, :share_price
        expose :location_str, as: :location
        expose :distance do |model, opts|
          model.try(:distance) || 0
        end
        expose :view_count, :sort
        expose :expired_on, format_with: :chinese_date
        expose :ad_type
        expose :ad_contents, if: proc { |a| a.ad_type != 2 } do |model, opts|
          model.ad_contents.map { |file| file.url }
        end
        expose :ad_link, if: proc { |a| a.ad_type == 2 and a.ad_link.present? }
      end
      
      # 消息
      class Message < Base
        expose :title do |model, opts|
          model.title || '系统公告'
        end#, format_with: :null
        expose :content, as: :body
        expose :created_at, format_with: :chinese_datetime
      end
      
      # 俱乐部
      class Club < Base
        expose :name, :title
        expose :intro, format_with: :null
        expose :relationships_count, as: :users_count
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:thumb)
        end
      end
      # 俱乐部详情
      class ClubDetail < Club
        expose :founded_on, format_with: :chinese_date
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:large)
        end
        expose :body
        expose :bylaw
        expose :has_joined do |model, opts|
          model.has_joined_for?(opts)
        end
        expose :latest_events, using: API::V1::Entities::Event do |model, opts|
          model.events.latest_starting.limit(5)
        end
        expose :latest_users, using: API::V1::Entities::UserProfile do |model, opts|
          model.users.order('relationships.id desc').limit(5)
        end
      end
      
      # 俱乐部章程
      class ClubDetail2 < Base
        expose :name, :bylaw
      end
      
      # 捐赠
      class Donate < Base
        expose :title
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:thumb)
        end
        expose :intro, format_with: :null
        expose :donated_on, format_with: :chinese_date
      end
      
      # 捐赠详情
      class DonateDetail < Base
        expose :title, :body
      end
      
      class Article < Base
        expose :title
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:thumb)
        end
        expose :intro, format_with: :null
        expose :published_at, format_with: :chinese_date
      end
      
      class ArticleDetail < Base
        expose :title, :body
      end
      
      # 基地
      class PracticeBase < Base
        expose :name, :intro
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:thumb)
        end
        expose :user, using: API::V1::Entities::UserProfile
      end
      
      # 基地详情
      class PracticeBaseDetail < PracticeBase
        expose :body
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:large)
        end
        expose :latest_events, using: API::V1::Entities::Event do |model, opts|
          model.events.latest_starting.limit(5)
        end
      end
      
      class PayHistory < Base
        expose :pay_name, format_with: :null
        expose :created_at, format_with: :chinese_datetime
        expose :pay_money do |model, opts|
          if model.pay_type == 0
            "+ ¥ #{model.money}"
          elsif model.pay_type == 1
            "- ¥ #{model.money}"
          else
            if model.pay_name == '打赏别人'
              "- ¥ #{model.money}"
            else
              "+ ¥ #{model.money}" # 收到打赏
            end
          end
        end
      end
      
      class Author < Base
        expose :nickname do |model, opts|
          model.nickname || model.mobile
        end
        expose :avatar do |model, opts|
          model.avatar.blank? ? "" : model.avatar_url(:large)
        end
      end
      
      # 提现
      class Withdraw < Base
        expose :bean, :fee
        expose :total_beans do |model, opts|
          model.bean + model.fee
        end
        expose :pay_type do |model, opts|
          if model.account_type == 1
            "微信提现"
          elsif model.account_type == 2
            "支付宝提现"
          else
            ""
          end
        end
        expose :state_info, as: :state
        expose :created_at, as: :time, format_with: :chinese_datetime
        expose :user, using: API::V1::Entities::Author
      end
      
      # Banner
      class Banner < Base
        expose :image do |model, opts|
          model.image.blank? ? "" : model.image.url(:large)
        end
        expose :link, format_with: :null
      end
      
      # 上网的状态
      class WifiStatus < Base
        expose :wifi_length, :login_count
        expose :last_login_at, format_with: :chinese_datetime
        expose :wifi_online
        expose :wifi_mac, as: :mac
        expose :ap_list do |model, opts|
          if opts.blank? or opts[:opts].blank? or opts[:opts][:ap_list].blank?
            []
          else
            opts[:opts][:ap_list]
          end
        end
      end
      
      class WifiChargePlan < Base
        expose :cid, :hour, :cost
      end
    
    end
  end
end
