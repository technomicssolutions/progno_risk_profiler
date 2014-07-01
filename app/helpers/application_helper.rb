module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s , :f => builder)
    end
    link_to_function(name, ("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def have_permissions(role)
    unless current_user.user_role==101
      _functions=((current_user.user_groups.map { |group| group.abilities.map{ |ability| ability.functions}}).join(",").split(","))
      if !(_functions.member?"#{role}")
        return false
      else
        return true
      end
    else
      return true
    end
  end

  def check_admin
    if current_user.user_role==101
      return true
    else
      return false
    end
  end
end
