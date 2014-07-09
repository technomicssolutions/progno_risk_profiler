class ChangeColumnRollingYearData < ActiveRecord::Migration
  def up
  	change_column :rolling_year_data, :data, :decimal, precision: 7, scale: 2
  end

  def down
  end
end
