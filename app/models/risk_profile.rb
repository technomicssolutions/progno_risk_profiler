class RiskProfile < ActiveRecord::Base
  attr_accessible :from_mark, :risk_profile_name, :to_mark
  belongs_to :risk_question_survey
  validates_presence_of :from_mark, :risk_profile_name, :to_mark
end
