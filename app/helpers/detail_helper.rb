module DetailHelper

  def edit_user_detail(id)
    link_to "edit" ,{:controller => 'detail' , :action => 'edit' ,:id => id}
  end

end
