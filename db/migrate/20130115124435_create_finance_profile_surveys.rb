class CreateFinanceProfileSurveys < ActiveRecord::Migration
  def change
    create_table :finance_profile_surveys do |t|
      t.string :nane

      t.timestamps
    end
  end
end
