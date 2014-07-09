class CreateRollingTimePeriods < ActiveRecord::Migration
  def change
    create_table :rolling_time_periods do |t|
      t.integer :asset_class_id
      t.integer :rolling_period_added
      t.string :data_unit
      t.integer :return_units_no
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
