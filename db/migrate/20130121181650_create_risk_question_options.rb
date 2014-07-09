class CreateRiskQuestionOptions < ActiveRecord::Migration
  def change
    create_table :risk_question_options do |t|
      t.integer :risk_question_id
      t.string :option_name
      t.integer :option_score
      t.text :option_comment

      t.timestamps
    end
  end
end
