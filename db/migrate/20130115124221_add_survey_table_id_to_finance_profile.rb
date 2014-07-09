class AddSurveyTableIdToFinanceProfile < ActiveRecord::Migration
  def change
  	add_column :financial_profile_questions, :finance_profile_survey, :integer
  end
end
