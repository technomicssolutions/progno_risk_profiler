module FrequentlyAskedQuestionHelper
  def add_faq_question
    link_to "Add new", {:controller => 'frequently_asked_question', :action => 'new'}
  end

  def edit_faq_question(question)
    link_to "&nbsp".html_safe ,{:controller => 'frequently_asked_question' , :action => 'edit' ,:id => question} ,:class=>"icon-large icon-pencil"
  end

  def destroy_faq_question(question)
    link_to "&nbsp".html_safe ,{:controller => 'frequently_asked_question' ,:action => 'destroy' , :id=> question} , :confirm =>"Are You Sure?" ,:method => :delete,:class=>"icon-large icon-trash"
  end
  def display_category_name(id)
    QuestionCategory.find(id).name
  end
  def destroy_faq_question_from_category(question)
    link_to "&nbsp".html_safe,{:controller => "frequently_asked_question" , :action  =>'destroy_from_category'  ,:id => question}, :confirm => "Are You Sure?",:method =>:delete,:class=>"icon-large icon-trash"
  end
end
