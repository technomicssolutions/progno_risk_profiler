class RollingPeriodMean < ActiveRecord::Base
  attr_accessible :asset_class_id, :mean, :rolling_time_period_id, :standard_deviation
  belongs_to :rolling_time_period
end
