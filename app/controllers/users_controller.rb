class UsersController < ApplicationController
  before_filter :authenticate_user! , :except => [:facebook, :linkedin, :google]
  def facebook
    if user_signed_in? && request.env["omniauth.auth"].provider=="facebook"
      session["info"]=current_user.make_info_fb(request.env["omniauth.auth"])
      sync_with_fb
    elsif !user_signed_in?
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        current_user.complete_facebook_invitation
        flash[:notice] = "Successfully logged in"# if is_navigational_format?
      else
        redirect_to new_user_registration_url
      end
    end
  end

  def linkedin
    if user_signed_in? && request.env["omniauth.auth"].provider=="linkedin"
      session["info"]=current_user.make_info_linkedin(request.env["omniauth.auth"])
      sync_with_linkedin
    elsif !user_signed_in?
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_linkedin_oauth(request.env["omniauth.auth"], current_user)

      if @user.persisted?
        @auth_info=request.env["omniauth.auth"]
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        flash[:notice] = "Successfully logged in"
      else
        @auth_info=request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end

  def google
    if user_signed_in? && request.env["omniauth.auth"].provider=="google"
      session["info"]=current_user.make_info_google(request.env["omniauth.auth"])
      sync_with_google
    else
      @user = User.find_for_open_id(request.env["omniauth.auth"], current_user)

      if @user.persisted?
        @auth_info=request.env["omniauth.auth"]
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        flash[:notice] = "Successfully logged in"
      else
        @auth_info=request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end

  def invite_contacts
    @contacts = request.env['omnicontacts.contacts']
  end

  def home

  end

  def index
    @user = User.find current_user.id
    @user_details = @user.user_detail

    @provider=request.env["omniauth.auth"].provider unless request.env["omniauth.auth"].nil?
  end

  def edit_professional
    @user = User.find current_user.id
    @user_details = @user.user_detail
    @auth_info=session["info"]
    if !@auth_info.nil?
      @provider=@auth_info[:provider]
    end
    if @user_details.nil?
      @user_details=UserDetail.new
      @user_details.user_id = current_user.id
      @user_details.save(validate: false)
      if !session["info"].nil?
        if session["info"][:provider]=="facebook"
          sync_with_fb
        elsif session["info"][:provider]=="linkedin"
          sync_with_linkedin
        elsif session["info"][:provider]=="google"
          sync_with_google
        end
      end
    end
  end

  def edit_personal
    @user = User.find current_user.id
    @user_details = @user.user_detail
    @auth_info=session["info"]
    if !@auth_info.nil? && !@auth_info.blank?
      @provider=@auth_info[:provider]
    end
    if @user_details.nil?
      user_details=UserDetail.new
      user_details.user_id = @user.id
      user_details.save(validate: false)
      @user_details = user_details
    end
    if !session["info"].nil?
      if session["info"][:provider]=="facebook"
        sync_with_fb
      elsif session["info"][:provider]=="linkedin"
        sync_with_linkedin
      elsif session["info"][:provider]=="google"
        sync_with_google
      end
    end
  end

  def update
    @user_details = UserDetail.find params[:user_detail][:id]
    if @user_details.update_attributes params[:user_detail]
      flash[:notice] = "Succesfully Updated"
      redirect_to users_profile_path
    else
      flash[:error] = @user_details.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  def edit_password
    @user = current_user
    if session["info"]
      render "password_change_for_indirect_sign_in"
    end
  end

  def update_password
    @user = current_user
    if !session["info"]
      if @user.update_with_password(params[:user])
        sign_in @user,:bypass => true
        flash[:notice] = "Password Updated Succesfully!!!"
        redirect_to users_profile_path
      else
        flash[:error] = @user.errors.full_messages.to_sentence
        @user_details = @user.user_detail
        render 'edit_password'
      end
    else
      if @user.update_attributes(params[:user])
        sign_in @user,:bypass => true
        flash[:notice] = "Password Updated Succesfully!!!"
        redirect_to users_profile_path
      else
        flash[:error] = @user.errors.full_messages.to_sentence
        @user_details = @user.user_detail
        render 'edit_password'
      end
    end
  end

  def create
    @user = Detail.new(params[:user_detail])
    if @user.save
      flash[:notice] = "profile Created Succesfully"
    else
      flash[:error] = @user.errors.messages.full_messages.to_sentence
      render 'new'
    end
  end

  def invitation_status
    @user=current_user
    @pending=current_user.invitation_not_accepted
    @accepted=current_user.invitation_accepted
    @rejected_history=current_user.invitation_histories.where(:status => "rejected").order('id DESC').limit(10)
    @rejected=@rejected_history.map { |history| User.find (history.invited)  }
  end

  def invite
    @user=current_user
    @pending=current_user.invitation_not_accepted
    @accepted=current_user.invitation_accepted
    @rejected_history=current_user.invitation_histories.where(:status => "rejected").order('id DESC').limit(10)
    @rejected=@rejected_history.map { |history| User.find (history.invited)  }
  end

  def bulk_invite

  end

  def send_bulk_invitations
    mail_ids = params[:user_mails]
    invitation_message = params[:invitation_message]
    if !mail_ids.blank?
      results = current_user.bulk_invite(mail_ids,current_user,invitation_message)
      flash[:notice] = results[0]
      flash[:error] = results[1]
      redirect_to users_invitation_status_path
    else
      flash[:error] = "Please Provide atleast one  Email id"
      redirect_to users_invite_path
    end

  end

  def sync_with_fb
    if !session["info"] || session["info"][:provider]!="facebook"
      redirect_to "/users/auth/facebook" and return
    end
    @user_details=current_user.get_details_fb(session["info"])
    render "edit"
  end

  def sync_with_linkedin
    if !session["info"] || session["info"][:provider]!="linkedin"
      redirect_to "/users/auth/linkedin" and return
    end
    @user_details=current_user.get_details_linkedin(session["info"])
    render "edit"
  end

  def sync_with_google
    if !session["info"] || session["info"][:provider]!="google"
      redirect_to "/users/auth/google" and return
    end
    @user_details=current_user.get_details_google(session["info"])
    render "edit"
  end

  def resend
    @pending_history=current_user.invitation_histories.where(:status => "pending")
    @users=@pending_history.reject { |history| history.invited.nil?}.map { |history| (User.find (history.invited)).email  }
  end

  def resend_invite
    resend=params[:users_emails]
    invitation_message = params[:invitation_message]
    resend.each do |email|
      current_user.invite_if_valid(email,current_user,invitation_message)
    end
    redirect_to users_invite_path
  end


  def more_invites
    @details=[]
    case params[:category]
    when "pending"
      invites=current_user.invites_not_accepted_full
      invites.each do |invite|
        @details<<[invite.email, " ", invite.invitation_sent_at]
      end
      @status = params[:category].camelize
    when "accepted"
      invites=current_user.invites_accepted_full
      invites.each do |invite|
        @details<<[invite.email, invite.try(:user_detail).try(:first_name), invite.invitation_accepted_at]
      end
      @status = params[:category].camelize
    when "rejected"
      rejected_history=current_user.invitation_histories.where(:status => "rejected")
      rejected=rejected_history.map { |history| User.find (history.invited)  }
      rejected.each do |invite|
        @details<<[invite.email, " ", invite.invitation_accepted_at]
      end
      @status = params[:category].camelize
    end
  end

  def facebook_invite
    user_ids = params[:user_ids].split(",")
    current_user.facebook_invite(user_ids)
    redirect_to users_invite_path
  end

end
