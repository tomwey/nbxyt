class MessageSession < ActiveRecord::Base
  belongs_to :sponsor, class_name: 'User', foreign_key: 'sponsor_id'
  belongs_to :actor,   class_name: 'User', foreign_key: 'actor_id'
  
  validates :actor_id, :sponsor_id, presence: true
  has_many :messages
  
  def unread_count_for(opts)
    return 0 if opts.blank?
    return 0 if opts[:opts].blank?
    return 0 if opts[:opts][:user].blank?
    
    user = opts[:opts][:user]
    
    @count ||= messages.where(unread: true, recipient_id: user.id).count
  end
  
  def user_info_for(opts)
    if opts.blank?
      nil
    else
      opts = opts[:opts]
      if opts.blank?
        nil
      else
        user = opts[:user]
        if user.blank?
          nil
        else
          if user.id == sponsor_id
            self.actor
          else
            self.sponsor
          end
        end
      end
    end
  end
  
end
