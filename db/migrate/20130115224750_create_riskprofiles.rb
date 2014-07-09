class CreateRiskprofiles < ActiveRecord::Migration
  def change
    create_table :riskprofiles do |t|
      t.string :name
      t.integer :from_mark
      t.integer :to_mark
      t.boolean :status

      t.timestamps
    end
  end
end
