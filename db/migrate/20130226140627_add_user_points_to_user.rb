class AddUserPointsToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_points, :integer
  end
end
