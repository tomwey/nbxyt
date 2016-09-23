class Organization < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :relationships, as: :relationshipable, dependent: :destroy
  has_many :users, through: :relationships
  
  has_many :events, as: :eventable
  
  scope :sorted, -> { order('sort desc, id desc') }
  
  mount_uploaders :detail_images, ImagesUploader
  
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
