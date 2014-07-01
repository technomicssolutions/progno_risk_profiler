class UserFinancialProfile < ActiveRecord::Base
  attr_accessible :finance_measure_id, :finance_measure_value, :user_id
  belongs_to :users
  validates_uniqueness_of :finance_measure_id, :scope => :user_id
end
