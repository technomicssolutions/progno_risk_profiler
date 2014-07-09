class AddImageToQuestionCategories < ActiveRecord::Migration
  def change
  	add_column :question_categories, :image_file_name , :string
  	add_column :question_categories ,:image_content_type,:string
  	add_column :question_categories , :image_file_size , :string
  	add_column :question_categories ,:image_updated_at ,:datetime
  end
end
