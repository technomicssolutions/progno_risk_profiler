class FinancialProfileQuestion < ActiveRecord::Base
  belongs_to :finance_profile_survey
  attr_accessible  :map_variable_id, :finance_profile_survey_id
  validates :question, uniqueness: true
end
