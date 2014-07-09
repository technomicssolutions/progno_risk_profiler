class CreateRiskoptions < ActiveRecord::Migration
  def change
    create_table :riskoptions do |t|
      t.integer :riskquestion_id
      t.string :option_name
      t.integer :score
      t.text :comment
      t.boolean :status

      t.timestamps
    end
  end
end
