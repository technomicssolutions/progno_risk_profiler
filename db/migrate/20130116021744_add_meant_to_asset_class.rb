class AddMeantToAssetClass < ActiveRecord::Migration
  def change

  	add_column :asset_classes, :mean_1, :real
  	add_column :asset_classes, :mean_2, :real
  	add_column :asset_classes, :mean_3, :real
  	add_column :asset_classes, :mean_4, :real
  	add_column :asset_classes, :mean_5, :real
  	add_column :asset_classes, :mean_6, :real
  	add_column :asset_classes, :mean_7, :real
  	add_column :asset_classes, :mean_8, :real
  	add_column :asset_classes, :mean_9, :real
  	add_column :asset_classes, :mean_10, :real

  	add_column :asset_classes, :stad_deviation_1, :real
  	add_column :asset_classes, :stad_deviation_2, :real
  	add_column :asset_classes, :stad_deviation_3, :real
  	add_column :asset_classes, :stad_deviation_4, :real
  	add_column :asset_classes, :stad_deviation_5, :real
  	add_column :asset_classes, :stad_deviation_6, :real
  	add_column :asset_classes, :stad_deviation_7, :real
  	add_column :asset_classes, :stad_deviation_8, :real
  	add_column :asset_classes, :stad_deviation_9, :real
  	add_column :asset_classes, :stad_deviation_10, :real
  end
end
