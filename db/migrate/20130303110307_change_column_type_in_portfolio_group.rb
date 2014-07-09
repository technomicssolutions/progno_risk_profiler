class ChangeColumnTypeInPortfolioGroup < ActiveRecord::Migration
  def up
  	change_column :portfolio_groups, :risk_free, :real
  end

  def down
  end
end
