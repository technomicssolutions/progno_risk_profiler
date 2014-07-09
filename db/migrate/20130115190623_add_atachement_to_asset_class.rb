class AddAtachementToAssetClass < ActiveRecord::Migration
  def change
  	add_attachment :asset_classes, :data_points
  end
end
