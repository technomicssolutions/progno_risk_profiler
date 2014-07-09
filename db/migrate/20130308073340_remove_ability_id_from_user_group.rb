class RemoveAbilityIdFromUserGroup < ActiveRecord::Migration
  def up
    remove_column :user_groups, :ability_id
  end

  def down
    add_column :user_groups, :ability_id, :integer
  end
end
