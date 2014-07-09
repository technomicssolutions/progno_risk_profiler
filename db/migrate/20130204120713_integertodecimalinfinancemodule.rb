class Integertodecimalinfinancemodule < ActiveRecord::Migration
  def up
  	change_column :finance_measure_options, :above_ideal_from, :decimal
  	change_column :finance_measure_options, :below_ideal_from, :decimal
  	change_column :finance_measure_options, :equal_ideal_from, :decimal

  	change_column :finance_measure_options, :above_ideal_to, :decimal
  	change_column :finance_measure_options, :below_ideal_to, :decimal
  	change_column :finance_measure_options, :equal_ideal_to, :decimal

  	change_column :finance_measure_options, :above_ideal_score, :decimal
  	change_column :finance_measure_options, :below_ideal_score, :decimal
  	change_column :finance_measure_options, :equal_ideal_score, :decimal

  end

  def down
  	change_column :finance_measure_options, :above_ideal_from, :integer
  	change_column :finance_measure_options, :below_ideal_from, :integer
  	change_column :finance_measure_options, :equal_ideal_from, :integer

  	change_column :finance_measure_options, :above_ideal_to, :integer
  	change_column :finance_measure_options, :below_ideal_to, :integer
  	change_column :finance_measure_options, :equal_ideal_to, :integer

  	change_column :finance_measure_options, :above_ideal_score, :integer
  	change_column :finance_measure_options, :below_ideal_score, :integer
  	change_column :finance_measure_options, :equal_ideal_score, :integer
  end
end
