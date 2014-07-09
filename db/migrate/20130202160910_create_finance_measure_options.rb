class CreateFinanceMeasureOptions < ActiveRecord::Migration
  def change
    create_table :finance_measure_options do |t|
      t.integer :above_ideal_from
      t.integer :above_ideal_to
      t.integer :above_ideal_score
      t.text :above_ideal_comment

			t.integer :equal_ideal_from
      t.integer :equal_ideal_to
      t.integer :equal_ideal_score
      t.text :equal_ideal_comment      

      t.integer :below_ideal_from
      t.integer :below_ideal_to
      t.integer :below_ideal_score
      t.text :below_ideal_comment  

      t.integer :finance_measure_id

      t.timestamps
    end
  end
end
