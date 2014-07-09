class CreateMapVariables < ActiveRecord::Migration
  def change
    create_table :map_variables do |t|
      t.string :name

      t.timestamps
    end
  end
end
