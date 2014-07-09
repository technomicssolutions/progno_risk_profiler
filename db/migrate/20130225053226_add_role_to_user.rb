class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer
    add_column :users, :user_level, :integer
  end
end
