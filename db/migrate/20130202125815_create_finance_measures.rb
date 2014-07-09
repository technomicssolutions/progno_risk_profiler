class CreateFinanceMeasures < ActiveRecord::Migration
  def change
    create_table :finance_measures do |t|
      t.string :name
      t.string :equation

      t.timestamps
    end
  end
end
