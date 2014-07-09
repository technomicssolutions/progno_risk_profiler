class AddNameToPortfolioGroupAsset < ActiveRecord::Migration
  def change
    add_column :portfolio_group_assets, :name, :string
  end
end
