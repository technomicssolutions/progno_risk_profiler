class AddToFinanceProfileSurvey < ActiveRecord::Migration
  def up
  	add_column :finance_profile_surveys, :report_message, :text
  end

  def down
  end
end
