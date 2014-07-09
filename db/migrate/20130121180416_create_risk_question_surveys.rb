class CreateRiskQuestionSurveys < ActiveRecord::Migration
  def change
    create_table :risk_question_surveys do |t|
      t.string :name

      t.timestamps
    end
  end
end
