class Organization < ActiveRecord::Base
  validates :name, :intro, :body, :image, :founded_on, presence: true
  
  has_many :relationships, as: :relationshipable, dependent: :destroy
  has_many :users, through: :relationships
  
  has_many :events, as: :eventable
  
  scope :sorted, -> { order('sort desc, id desc') }
  
  # mount_uploaders :detail_images, ImagesUploader
  mount_uploader :image, ImageUploader
  mount_uploaders :images, ImagesUploader
  
  def all_users_count
    @total ||= Organization.where.not(name: '校友总会').sum(:relationships_count)
  end
  
  def all_images
    result = []
    images.each do |image|
      result << image.url(:large)
    end
    result
  end
  
  def all_latest_events
    @events ||= Event.where(eventable_type: 'Organization').order('started_at desc, id desc').limit(5)
  end
  
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
