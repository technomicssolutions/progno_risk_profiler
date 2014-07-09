class CreateFinancialProfiles < ActiveRecord::Migration
  def change
    create_table :financial_profiles do |t|
      t.string :name 
      t.text	 :question 
      t.text	 :above_ideal_comment
      t.text     :question 
      t.text     :above_ideal_comment
      t.text   :below_ideal_comment
      t.text   :equal_ideal_comment
      t.integer :above_ideal
      t.integer :below_ideal 
      t.integer :equal_ideal 
      
      t.timestamps
    end
  end
end
