class CreateRiskquestionSurveys < ActiveRecord::Migration
  def change
    create_table :riskquestion_surveys do |t|
      t.string :name

      t.timestamps
    end
  end
end
