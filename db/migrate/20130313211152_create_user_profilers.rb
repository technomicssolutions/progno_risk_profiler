class CreateUserProfilers < ActiveRecord::Migration
  def change
    create_table :user_profilers do |t|
      t.integer :user_id
      t.integer :efficient_frontier_id
      t.decimal :utility
      t.decimal :risk_penalty

      t.timestamps
    end
  end
end
