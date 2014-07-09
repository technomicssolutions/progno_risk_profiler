class CreateRollingPeriodCorrelations < ActiveRecord::Migration
  def change
    create_table :rolling_period_correlations do |t|
      t.decimal :asset_class_item_one_id
      t.decimal :asset_class_item_two_id
      t.decimal :corelations
      t.integer :rolling_time_period_id
      t.timestamps
    end
  end
end
