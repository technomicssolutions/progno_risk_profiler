class AddStatusToPortfolioGroup < ActiveRecord::Migration
  def change
    add_column :portfolio_groups, :status, :boolean, :default=> true
  end
end
