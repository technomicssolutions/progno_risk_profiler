class RollingPeriodCorrelation < ActiveRecord::Base
  belongs_to :rolling_time_period
  attr_accessible :asset_class_item_one_id, :asset_class_item_two_id, :corelations, :rolling_time_period_id
end
