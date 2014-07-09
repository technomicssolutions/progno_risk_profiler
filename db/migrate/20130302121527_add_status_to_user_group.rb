class AddStatusToUserGroup < ActiveRecord::Migration
  def change
    add_column :user_groups, :status, :boolean, :default=>true
  end
end
