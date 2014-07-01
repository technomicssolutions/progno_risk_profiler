class RollingPeriodCorrelation < ActiveRecord::Base
  belongs_to :rolling_period
  attr_accessible :asset_class_item_one_id, :asset_class_item_two_id, :corelations, :rolling_period_id
end
