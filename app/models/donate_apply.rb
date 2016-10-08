class DonateApply < ActiveRecord::Base
  validates :content, :contact, presence: true
end
