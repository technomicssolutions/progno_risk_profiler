class AddMapVariableToFiancialProfileQuestion < ActiveRecord::Migration
  def change
  	add_column :financial_profile_questions, :map_variable_id, :integer
  end
end
