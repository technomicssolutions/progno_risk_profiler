class AddOderToRiskQuestions < ActiveRecord::Migration
  def change
  	add_column :risk_questions, :order, :integer
  end
end
