class AddCategoryIdToFrequentlyAskedQuestion < ActiveRecord::Migration
  def change
    add_column :frequently_asked_questions, :category_id, :integer
  end
end
