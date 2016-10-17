class Message < ActiveRecord::Base
  belongs_to :message_session, counter_cache: true
  
  belongs_to :sender,    class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  
  validates :content, :sender_id, :recipient_id, :message_session_id, presence: true
  
  before_create :generate_msg_id
  def generate_msg_id
    self.msg_id = SecureRandom.uuid.gsub('-', '') if self.msg_id.blank?
  end
  
  def from_me_for?(opts)
    if opts.blank?
      false
    else
      opts = opts[:opts]
      if opts.blank?
        false
      else
        user = opts[:user]
        if user.blank?
          false
        else
          user.id == sender_id
        end
      end
    end
  end

end
