class AddAssetClassIdToRollingPerioid < ActiveRecord::Migration
  def change
  	add_column :rolling_year_data, :asset_class_id, :integer
  end
end
