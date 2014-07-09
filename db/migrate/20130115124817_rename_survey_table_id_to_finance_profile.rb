class RenameSurveyTableIdToFinanceProfile < ActiveRecord::Migration
  def up
  	rename_column :financial_profile_questions, :finance_profile_survey, :finance_profile_survey_id

  end

  def down
  end
end
