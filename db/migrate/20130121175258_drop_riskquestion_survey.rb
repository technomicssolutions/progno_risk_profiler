class DropRiskquestionSurvey < ActiveRecord::Migration
  def up
  	drop_table :riskquestion_surveys
  end

  def down
  end
end
