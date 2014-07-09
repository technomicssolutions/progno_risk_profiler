class CreateAbilityGroupMappings < ActiveRecord::Migration
  def change
    create_table :ability_group_mappings do |t|
      t.integer :ability_id
      t.integer :user_group_id

      t.timestamps
    end
  end
end
