class AddRollingColumnsToAssetData < ActiveRecord::Migration
  def change
  	add_column :asset_data, :rolling_1, :real
  	add_column :asset_data, :rolling_2, :real
  	add_column :asset_data, :rolling_3, :real
  	add_column :asset_data, :rolling_4, :real
  	add_column :asset_data, :rolling_5, :real
  	add_column :asset_data, :rolling_6, :real
  	add_column :asset_data, :rolling_7, :real
  	add_column :asset_data, :rolling_8, :real
  	add_column :asset_data, :rolling_9, :real
  	add_column :asset_data, :rolling_10, :real


  end
end
