class ChangeDefaultUserRoles < ActiveRecord::Migration
  def up
  	change_column :users, :user_level, :integer, :default => 1
  	change_column :users, :user_role, :integer, :default => 301
  end

  def down
  	change_column :users, :user_level, :integer, :default => 'NULL'
  	change_column :users, :user_role, :integer, :default => 'NULL'
  end
end
