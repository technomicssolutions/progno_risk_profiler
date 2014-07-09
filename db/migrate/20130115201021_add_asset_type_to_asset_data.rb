class AddAssetTypeToAssetData < ActiveRecord::Migration
  def change
  	add_column :asset_data, :asset_class_id, :integer
  end
end
