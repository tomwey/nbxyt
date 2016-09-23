class Relationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :relationshipable, polymorphic: true, counter_cache: true
end
