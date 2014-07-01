class FinancialProfileQuestion < ActiveRecord::Base
  belongs_to :finance_profile_survey
  attr_accessible :question, :finance_profile_survey_id , :map_variable_id
  validates :question, uniqueness: true
  validates :map_variable_id, uniqueness: true
end
