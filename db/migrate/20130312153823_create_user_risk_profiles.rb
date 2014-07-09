class CreateUserRiskProfiles < ActiveRecord::Migration
  def change
    create_table :user_risk_profiles do |t|
      t.integer :user_id
      t.integer :risk_question_id
      t.integer :risk_question_option_id

      t.timestamps
    end
  end
end
