class CreateRiskQuestions < ActiveRecord::Migration
  def change
    create_table :risk_questions do |t|
      t.integer :risk_question_survey_id
      t.text :risk_question

      t.timestamps
    end
  end
end
