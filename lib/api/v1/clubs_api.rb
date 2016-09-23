module API
  module V1
    class ClubsAPI < Grape::API
      
      resource :clubs, desc: '校友俱乐部相关接口' do
        desc "获取俱乐部"
      end # end resource
      
    end
  end
end