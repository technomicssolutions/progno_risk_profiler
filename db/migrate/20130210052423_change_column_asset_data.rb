class ChangeColumnAssetData < ActiveRecord::Migration
  def up
  	change_column :asset_data, :data, :decimal, precision: 7, scale: 2
  end

  def down
  end
end
