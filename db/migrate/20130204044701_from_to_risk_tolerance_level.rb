class FromToRiskToleranceLevel < ActiveRecord::Migration
  def up
  	rename_column :risk_tolerance_levels, :from, :from_value
  	rename_column :risk_tolerance_levels, :to, :to_value
  end

  def down
  	rename_column :risk_tolerance_levels, :from_value, :from
  	rename_column :risk_tolerance_levels, :to_value, :to
  end
end
