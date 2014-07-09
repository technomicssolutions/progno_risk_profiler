class CreatePortfolioGroups < ActiveRecord::Migration
  def change
    create_table :portfolio_groups do |t|
      t.string :name
      t.integer :time_horizon
      t.integer :rolling_time_period_id

      t.timestamps
    end
  end
end
