class AddIdealToFinancialProfileQuestion < ActiveRecord::Migration
  def change
  	add_column :financial_profile_questions, :ideal, :integer
  	change_column :financial_profile_questions, :above_ideal, :string
  	change_column :financial_profile_questions, :below_ideal, :string
  	change_column :financial_profile_questions, :equal_ideal, :string
  end
end
