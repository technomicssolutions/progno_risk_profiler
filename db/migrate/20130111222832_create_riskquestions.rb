class CreateRiskquestions < ActiveRecord::Migration
  def change
    create_table :riskquestions do |t|
     t.text :question
     t.boolean :status
     t.integer :riskquestion_survey_id
     t.timestamps
    end
  end
end
