class ChangeRoleToUserRole < ActiveRecord::Migration
  def up
  	rename_column :users, :role, :user_role
  end

  def down
  end
end
