class RiskQuestionOption < ActiveRecord::Base
  attr_accessible :option_comment, :option_name, :option_score, :risk_question_id
  belongs_to :risk_question
end
