class RiskToleranceLevel < ActiveRecord::Base
  attr_accessible :from_value, :level, :to_value
  validates_presence_of :from_value,:level,:to_value
end
