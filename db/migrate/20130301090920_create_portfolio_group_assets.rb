class CreatePortfolioGroupAssets < ActiveRecord::Migration
  def change
    create_table :portfolio_group_assets do |t|
      t.integer :asset_class_id
      t.integer :portfolio_group_id
      t.integer :minimum
      t.integer :maximum

      t.timestamps
    end
  end
end
