class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.integer :user_id
      t.string :first_name
      t.string :second_name
      t.date :date_of_birth
      t.text :address
      t.string :company_name
      t.text :company_details
      t.string :designation

      t.timestamps
    end
  end
end
