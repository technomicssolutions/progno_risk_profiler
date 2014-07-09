class CreateFinancialProfileQuestions < ActiveRecord::Migration
  def change
    create_table :financial_profile_questions do |t|
      t.string :name 
      t.text :question
      t.integer :above_ideal
      t.integer :below_ideal
      t.integer :equal_ideal
      t.text :above_ideal_comment
      t.text :below_ideal_comment
      t.text :equal_ideal_comment

      t.timestamps
    end
  end
end
