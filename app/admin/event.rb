ActiveAdmin.register Event do

permit_params :title, :body, :image, :started_at, :ended_at, :total_attends, :sort, :eventable_type, :eventable_id

# actions :all, except: :new
config.remove_action_item(:new)
# config.options = { blank_slate_link: '' }

index do
  selectable_column
  column('ID',:id)
  column(:title, sortable: false)
  column :image, sortable: false do |event|
    image_tag event.image_url(:small)
  end
  column :started_at
  column :ended_at
  column '参加人数' do |event|
    "#{event.attends_count} / #{event.total_attends}"
  end
  column '所有者', sortable: false do |event|
    if event.eventable
      "【#{event.eventable.class.model_name.human}】#{event.eventable.name}"
    else
      ""
    end
  end
  column :sort
  actions defaults: false do |event|
    item "查看", cpanel_event_path(event)
    item "编辑", "#{edit_cpanel_event_path(event)}?type=#{event.eventable.try(:class)}&id=#{event.eventable.try(:id)}"
    item "删除", cpanel_event_path(event), method: :delete, data: { confirm: '您确定吗？' }
  end
end

form html: { multipart: true } do |f|
  f.semantic_errors
  
  f.inputs do
    f.input :title, placeholder: '活动主题'
    f.input :body, as: :text, input_html: { class: 'redactor' },
       placeholder: '活动详情，支持图文混排', hint: '活动详情，支持图文混排'
    f.input :image, as: :file, hint: '图片格式为：jpg, jpeg, png, gif；尺寸为：750x512'
    f.input :started_at, as: :string, placeholder: '例如：2016-01-01 12:00:00', hint: '日期字符串，格式为：年-月-日 时-分-秒，例如：2016-10-01 13:39:20'
    f.input :ended_at, as: :string, placeholder: '例如：2016-01-01 12:00:00', hint: '日期字符串，格式为：年-月-日 时-分-秒，例如：2016-10-01 13:39:20'
    f.input :total_attends, hint: '参加活动的人数，如果值为0，表示此活动只是一个公告性质的活动，不要求用户强制参加，适用于校友会发布的活动；如果该活动要求用户参加，则需要设置一个大于0的整数来限制该活动的参加人数，适用于校友俱乐部发布的活动'
    f.input :sort, hint: '值越大显示越靠前'
    f.input :eventable_type, as: :hidden, input_html: { value: "#{params[:type]}" }
    f.input :eventable_id,   as: :hidden, input_html: { value: "#{params[:id]}" }
  end
    
  actions
  
end

end
