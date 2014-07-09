class AddYearMonthDaysToAssetClass < ActiveRecord::Migration
  def change
  	add_column :asset_classes, :no_of_years, :integer
  	add_column :asset_classes, :no_of_days, :integer
  	add_column :asset_classes, :no_of_months, :integer
  end
end
