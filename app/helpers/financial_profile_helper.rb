module FinancialProfileHelper
  def new_question
    link_to "Add Question", {:controller => 'financial_profile', :action => 'new'}, :remote => true
  end

  def edit_finance_question(question)
    link_to '&nbsp'.html_safe, {:controller => 'financial_profile',:action => 'edit', :id => question.id}, :method => 'post', :remote => true ,:class =>"icon-large icon-pencil"
  end

  def delete_finance_question(question)
    link_to '&nbsp'.html_safe, {:controller => "financial_profile", :action => 'destroy', :id => question.id}, :confirm => "Are you sure you want to Delete", :method => :delete , :class =>"icon-large icon-trash "
  end

  def add_measure_options
    link_to "Add options", {:controller => 'financial_profile', :action => 'measure_options'}, :remote => true
  end

  def edit_measure_option(id)
    link_to '&nbsp'.html_safe, {:controller => 'financial_profile',:action => 'measure_options_edit', :id => id}, :method => 'post', :remote => true  , :class =>"icon-large icon-pencil"
  end

  def measure_name(id)
    FinanceMeasure.find(id).name unless id.nil?
  end

  def delete_measure_option(id)
    link_to '&nbsp'.html_safe, {:controller => "financial_profile", :action => 'measure_options_destroy', :id => id}, :confirm => "Are you sure you want to Delete", :method => :delete , :class =>"icon-large icon-trash"
  end

  def map_variable_name(id)
    MapVariable.find(id).name unless id.nil?
  end
end
