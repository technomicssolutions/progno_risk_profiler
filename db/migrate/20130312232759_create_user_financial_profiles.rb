class CreateUserFinancialProfiles < ActiveRecord::Migration
  def change
    create_table :user_financial_profiles do |t|
      t.integer :user_id
      t.integer :finance_measure_id
      t.decimal :finance_measure_value

      t.timestamps
    end
  end
end
