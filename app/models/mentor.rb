class Mentor < ActiveRecord::Base
  belongs_to :college
  belongs_to :user
  
  def verify!
    self.verified = true
    self.save!
  end
  
  def cancel_verify!
    self.verified = false
    self.save!
  end
end
