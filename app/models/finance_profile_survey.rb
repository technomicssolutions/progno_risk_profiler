class FinanceProfileSurvey < ActiveRecord::Base
  has_many :financial_profile_questions
  accepts_nested_attributes_for :financial_profile_questions, :allow_destroy => true
  attr_accessible :nane,:report_message, :financial_profile_questions_attributes
end
