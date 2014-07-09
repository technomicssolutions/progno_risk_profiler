class AddSharpeRatioToPortfolioGroup < ActiveRecord::Migration
  def change
    add_column :efficient_frontiers, :sharpe_ratio, :real
  end
end
