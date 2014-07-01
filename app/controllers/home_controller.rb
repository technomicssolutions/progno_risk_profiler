class HomeController < ApplicationController
  layout false

  def index
    if user_signed_in? then
      redirect_to users_profile_path
    end
    if params[:request_ids] then
      redirect_to '/users/auth/facebook'
    end
    #@facebook_requests_ids = params[:request_ids].split(",") if params[:request_ids]
  end

  def sign_up
    #ToDo sign up using popup from home page
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

end
