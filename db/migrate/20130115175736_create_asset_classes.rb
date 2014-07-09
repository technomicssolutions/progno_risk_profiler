class CreateAssetClasses < ActiveRecord::Migration
  def change
    create_table :asset_classes do |t|
      t.string :main_asset_class
      t.string :sub_asset_class
      t.string :benchmark

      t.timestamps
    end
  end
end
