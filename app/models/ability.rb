class Ability < ActiveRecord::Base
  attr_accessible :name, :remark, :status, :functions
  validates_presence_of :functions
  has_many :user_groups, :through=>:abiity_group_mapping
  has_many :ability_group_mappings, :dependent=>:destroy
end
