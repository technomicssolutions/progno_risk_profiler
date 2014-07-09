class ChangeColumnTrypOfEfficientFrontier < ActiveRecord::Migration
  def up
  	change_column :efficient_frontiers, :return, :real
  	change_column :efficient_frontiers, :risk, :real
  	
  end

  def down
  end
end
