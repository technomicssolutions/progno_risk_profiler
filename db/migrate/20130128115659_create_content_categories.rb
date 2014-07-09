class CreateContentCategories < ActiveRecord::Migration
  def change
    create_table :content_categories do |t|
      t.string :name
      t.boolean :status

      t.timestamps
    end
  end
end
