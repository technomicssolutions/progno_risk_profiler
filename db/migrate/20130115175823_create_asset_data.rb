class CreateAssetData < ActiveRecord::Migration
  def change
    create_table :asset_data do |t|
    	t.datetime :date
    	t.integer :data

      t.timestamps
    end
  end
end
