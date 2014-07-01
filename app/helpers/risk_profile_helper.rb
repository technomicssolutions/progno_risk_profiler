module RiskProfileHelper

  def edit_question(question_id)
    link_to '&nbsp'.html_safe , {:controller => 'risk_profile',:action => 'edit_question', :id => question_id }, :method => 'post', :remote => true, :class=>"icon-large icon-pencil"
  end

  def delete_question(question_id)
    link_to '&nbsp'.html_safe , {:controller => "risk_profile", :action => 'destroy', :id => question_id}, :confirm => "Are you sure you want to Delete", :method => :delete , :class=> "icon-large icon-trash"
  end

  def add_question
    link_to "Add question", {:controller => 'risk_profile', :action => 'new_questions'}, :remote => true, :class=> "icon-large icon-plus"
  end

  def add_option(question_id)
    link_to '&nbsp'.html_safe , {:controller => 'risk_profile', :action => 'add_option', :id => question_id}, :remote => true, :class=> "icon-large icon-plus"
  end

  def edit_option(option_id)
    link_to '&nbsp'.html_safe , {:controller => 'risk_profile',:action => 'edit_option', :id => option_id}, :method => 'post',  :remote => true, :class=>"icon-large icon-pencil"
  end

  def delete_option(option_id)
    link_to '&nbsp'.html_safe , {:controller => "risk_profile", :action => 'delete_option', :id => option_id}, :confirm => "Are you sure you want to Delete", :method => :delete, :class=> "icon-large icon-trash"
  end

  def format_question(question,number)
    return "Q" + (number +1).to_s + question.gsub(/<p>/,"  ")
  end

  def question_number(number)
    return "Q" + (number +1).to_s
  end

  def option_number(question_number,option_number)
    return (question_number +1).to_s + "." + option_number.to_s.tr("0-9","A-J")
  end

  def add_risk_profile
    link_to "Add New Profile", {:controller => 'risk_profile', :action => 'new_risk_profile'}, :remote => true
  end

end
