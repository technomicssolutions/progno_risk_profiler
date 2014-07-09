class AddUploadTimeToAssetData < ActiveRecord::Migration
  def change
  	add_column :asset_data, :upload_time, :datetime
  end
end
