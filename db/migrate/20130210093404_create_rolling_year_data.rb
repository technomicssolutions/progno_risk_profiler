class CreateRollingYearData < ActiveRecord::Migration
  def change
    create_table :rolling_year_data do |t|
    	t.datetime :date
    	t.integer :asset_classes_id
    	t.decimal :data 
    	t.integer :rolling_period
      t.timestamps
    end
  end
end
