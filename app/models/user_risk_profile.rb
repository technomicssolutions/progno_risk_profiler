class UserRiskProfile < ActiveRecord::Base
  attr_accessible :risk_question_id, :risk_question_option_id, :user_id
  validates_uniqueness_of :risk_question_id, :scope => :user_id
end
