class RiskQuestionSurvey < ActiveRecord::Base
  has_many :risk_questions
  has_many :risk_profiles
  accepts_nested_attributes_for :risk_questions, :allow_destroy => true
  accepts_nested_attributes_for :risk_profiles, :allow_destroy => true
  attr_accessible :name, :risk_questions_attributes, :risk_profiles_attributes

end
