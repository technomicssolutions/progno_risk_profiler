class AbilityGroupMapping < ActiveRecord::Base
  attr_accessible :ability_id, :user_group_id
  belongs_to :ability
  belongs_to :user_group
end
