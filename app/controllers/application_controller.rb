class ApplicationController < ActionController::Base
  include CsrfTokenCaching
  protect_from_forgery

  def is_admin
    if current_user.user_role==101
      return true
    else
      redirect_to "/un_authorized?id=#{request.host}:#{request.port}#{request.fullpath}"
    end
  end

  def can_manage(role)
    unless current_user.user_role==101
      functions=((current_user.user_groups.map { |group| group.abilities.map{ |ability| ability.functions}}).join(",").split(","))
      if !(functions.member?"#{role}")
        redirect_to "/un_authorized?id=#{request.host}:#{request.port}#{request.fullpath}"
      end
    else
      return true
    end
  end

  def after_sign_in_path_for(resource)
    hash=request.env["omniauth.auth"]
    if !hash.nil?
      if hash.provider=="facebook"
        user_info=current_user.make_info_fb(hash)
      elsif hash.provider=="linkedin"
        user_info=current_user.make_info_linkedin(hash)
      elsif hash.provider=="google"
        user_info=current_user.make_info_google(hash)
      end
    end

    session["info"]=user_info
    if current_user.user_role==101
      return admin_dashboard_path
    end

    if current_user.user_detail.nil?
      return users_profile_edit_personal_path
    else
      return users_profile_path
    end
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  protected
  def is_i?(str)
    !!(str =~ /^[-+]?[0-9]+$/)
  end
end
