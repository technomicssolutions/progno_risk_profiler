class CreateEfficientFrontiers < ActiveRecord::Migration
  def change
    create_table :efficient_frontiers do |t|
      t.string :composition
      t.integer :risk
      t.integer :return
      t.integer :portfolio_group_id

      t.timestamps
    end
  end
end
