class ChangeColumnTypeInAssetData < ActiveRecord::Migration
  def up
  	change_column :asset_data, :rolling_1, :decimal, precision: 7, scale: 2
  	change_column :asset_data, :rolling_2, :decimal, precision: 7, scale: 2
  	change_column :asset_data, :rolling_3, :decimal, precision: 7, scale: 2
  	change_column :asset_data, :rolling_4, :decimal, precision: 7, scale: 2
  	change_column :asset_data, :rolling_5, :decimal, precision: 7, scale: 2
  	change_column :asset_data, :rolling_6, :decimal, precision: 7, scale: 2
  	change_column :asset_data, :rolling_7, :decimal, precision: 7, scale: 2
  	change_column :asset_data, :rolling_8, :decimal, precision: 7, scale: 2
  	change_column :asset_data, :rolling_9, :decimal, precision: 7, scale: 2
  	change_column :asset_data, :rolling_10, :decimal, precision: 7, scale: 2

  	change_column :asset_classes, :mean_1, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :mean_2, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :mean_3, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :mean_4, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :mean_5, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :mean_6, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :mean_7, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :mean_8, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :mean_9, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :mean_10, :decimal, precision: 7, scale: 2

  	change_column :asset_classes, :stad_deviation_1, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :stad_deviation_2, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :stad_deviation_3, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :stad_deviation_4, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :stad_deviation_5, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :stad_deviation_6, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :stad_deviation_7, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :stad_deviation_8, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :stad_deviation_9, :decimal, precision: 7, scale: 2
  	change_column :asset_classes, :stad_deviation_10, :decimal, precision: 7, scale: 2
  end

  def down
  end
end
