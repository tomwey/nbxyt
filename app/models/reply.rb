class Reply < ActiveRecord::Base
  belongs_to :replyable, polymorphic: true
  
  validates :sender, :content, presence: true
  
  scope :latest, -> { order('id desc') } 
  
  def from_user
    @user ||= User.find_by(id: sender)
  end
  
  def to_user
    @user ||= User.find_by(id: receiver)
  end
end
