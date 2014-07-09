class ChangeCOlumnOfEfficientFrontier < ActiveRecord::Migration
  def up
  	change_column :efficient_frontiers, :risk, :decimal, precision: 7, scale: 4
  	change_column :efficient_frontiers, :return, :decimal, precision: 7, scale: 4
  	change_column :efficient_frontiers, :sharpe_ratio, :decimal, precision: 7, scale: 4
  end

  def down
  end
end
