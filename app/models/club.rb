class Club < ActiveRecord::Base
  validates :name, :title, :body, :intro, :image, :bylaw, :founded_on, presence: true
  
  has_many :events, as: :eventable
  
  has_many :relationships, as: :relationshipable, dependent: :destroy
  has_many :users, through: :relationships
  
  mount_uploader :image, ImageUploader
  
  def has_joined_for?(opts)
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
          user.has_joined?(self)
        end
      end
    end
  end
end
