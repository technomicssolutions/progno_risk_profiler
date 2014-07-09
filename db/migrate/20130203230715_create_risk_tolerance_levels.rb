class CreateRiskToleranceLevels < ActiveRecord::Migration
  def change
    create_table :risk_tolerance_levels do |t|
      t.string :level
      t.integer :from
      t.integer :to

      t.timestamps
    end
  end
end
