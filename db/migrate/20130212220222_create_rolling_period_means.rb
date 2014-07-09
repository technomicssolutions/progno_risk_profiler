class CreateRollingPeriodMeans < ActiveRecord::Migration
  def change
    create_table :rolling_period_means do |t|
      t.decimal :mean
      t.decimal :standard_deviation
      t.integer :asset_class_id
      t.integer :rolling_time_period_id

      t.timestamps
    end
  end
end
