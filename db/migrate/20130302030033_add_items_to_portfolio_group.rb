class AddItemsToPortfolioGroup < ActiveRecord::Migration
  def change
    add_column :portfolio_groups, :weight_change, :integer
    add_column :portfolio_groups, :risk_free, :integer
  end
end
