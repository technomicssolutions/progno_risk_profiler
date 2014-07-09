class CreateSiteContents < ActiveRecord::Migration
  def change
    create_table :site_contents do |t|
      t.string :page_url
      t.text :content
      t.boolean :published

      t.timestamps
    end
  end
end
