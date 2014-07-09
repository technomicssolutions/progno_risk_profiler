class CreateContentArticles < ActiveRecord::Migration
  def change
    create_table :content_articles do |t|
      t.integer :content_category_id
      t.string :title
      t.text :body
      t.integer :user_id
      t.boolean :published
      t.boolean :public

      t.timestamps
    end
  end
end
