class CreateRiskProfiles < ActiveRecord::Migration
  def change
    create_table :risk_profiles do |t|
    	t.integer :risk_question_survey_id
      t.string :risk_profile_name
      t.integer :from_mark
      t.integer :to_mark

      t.timestamps
    end
  end
end
