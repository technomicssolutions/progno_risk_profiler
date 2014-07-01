module QuestionCategoryHelper
  def add_faq_category
    link_to "Add Category", {:controller => 'question_category', :action => 'new'}
  end

  def edit_faq_category(category)
    link_to "&nbsp".html_safe, {:controller => 'question_category', :action => 'edit' , :id=>category },:class=>"icon-large icon-pencil"
  end

  def delete_faq_category(category)
    link_to "&nbsp".html_safe, {:controller => 'question_category', :action => 'destroy' , :id=>category } ,:confirm => "Are you sure ??",:method => :delete,:class=>"icon-large icon-trash"
  end
end
