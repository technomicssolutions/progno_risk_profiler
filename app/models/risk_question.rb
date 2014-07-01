class RiskQuestion < ActiveRecord::Base
  belongs_to :risk_question_survey
  has_many :risk_question_options
  accepts_nested_attributes_for :risk_question_options, :reject_if => lambda { |a| a[:option_name].blank? }, :allow_destroy => true
  attr_accessible :risk_question, :risk_question_survey_id, :risk_question_options_attributes
  before_save :set_survey_id, :on => :create

  def set_survey_id
    survey = RiskQuestionSurvey.first.id rescue create_survey
    self.risk_question_survey_id = 1
  end

  def create_survey
    survey = RiskQuestionSurvey.create(id:1,name:"riskprofile survey")
    survey.save
  end
end
