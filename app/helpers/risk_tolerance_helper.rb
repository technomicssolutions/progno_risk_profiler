module RiskToleranceHelper

  def new_rta_level
    link_to "Add New Level", {:controller => 'risk_tolerance', :action => 'new'}, :remote => true
  end

  def edit_rta(level)
    link_to " ", {:controller => 'risk_tolerance',:action => 'edit', :id => level.id}, :method => 'post', :remote => true , :class => "icon-large icon-pencil"
  end

  def delete_rta(level)
    link_to " ", {:controller => "risk_tolerance", :action => 'destroy', :id => level.id}, :confirm => "Are you sure you want to Delete", :method => :delete , :class =>"icon-large icon-trash"
  end
end
