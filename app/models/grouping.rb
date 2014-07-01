class Grouping < ActiveRecord::Base
  attr_accessible :user_group_id, :user_id
  belongs_to :user
  belongs_to :user_group
  validates_uniqueness_of :user_id, :scope=>:user_group_id
end
