class FinanceMeasure < ActiveRecord::Base
  has_one :finance_measure_options
  attr_accessible :equation, :name
end
