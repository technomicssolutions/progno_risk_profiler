module AdvisorHelper

  def advisor_view_details(user)
    link_to user.user_detail.full_name, {:controller => 'advisor', :action => 'select_user', :id=> user.id}
  end

  def advisor_profiling(user)
    user.profiling ? '<i class="icon-ok">'.html_safe : '<i class=" icon-remove">'.html_safe
  end

  def view_profiling(user)
    link_to "   View Profiling", {:controller => 'advisor', :action => 'view_profiling', :id=> user.id}, :remote => true
  end

  def display_composition(composition)
    text = ""
    composition.each do |c|
      text += c[0] + " : " + c[1].to_s + "%" + "<br>"
    end
    text.html_safe
  end
end
