class CreateGroupings < ActiveRecord::Migration
  def change
    create_table :groupings do |t|
      t.integer :user_group_id
      t.integer :user_id

      t.timestamps
    end
  end
end
