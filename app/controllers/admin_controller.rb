class AdminController < ApplicationController

  before_filter :authenticate_user!
  before_filter :is_admin, :only=>[:dashboard, :users_summary]
  before_filter(:except=>[:dashboard, :users_summary]) {|c| c.can_manage(1) }
  def users_summary
    @pending=[]
    @accepted=[]
    pending_invites=InvitationHistory.where status:"pending"
    pending_invites.each do |pending|
      @pending<<[(User.find pending.invited).email, (User.find pending.user_id).email, pending.updated_at]
    end
    accepted_invites=InvitationHistory.where status:"accepted"
    accepted_invites.each do |accepted|
      @accepted<<[(User.find accepted.invited).email, (User.find accepted.user_id).email, accepted.updated_at]
    end
  end

  def dashboard
    @total_invites_this_month=InvitationHistory.find(:all, :conditions=>['status!=? AND updated_at<? AND updated_at>?', "rejected",  Time.now, (Date.current-30).to_datetime])
    @accepted_this_month=(@total_invites_this_month.map {|invites| invites unless invites.status!="accepted"}).reject {|invite| invite.nil?}
    @pending_this_month=(@total_invites_this_month.map {|invites| invites unless invites.status!="pending"}).reject {|invite| invite.nil?}

    @total_invites_today = @total_invites_this_month.select {|date| date.updated_at >= Date.current.to_datetime}
    @accepted_today=(@total_invites_today.map {|invites| invites unless invites.status!="accepted"}).reject {|invite| invite.nil?}
    @pending_today=(@total_invites_today.map {|invites| invites unless invites.status!="pending"}).reject {|invite| invite.nil?}

    @total_invites_this_week=@total_invites_this_month.select {|date| date.updated_at.to_datetime.cweek==Time.now.to_datetime.cweek &&  date.updated_at.year==Time.now.year}
    @accepted_this_week=(@total_invites_this_week.map {|invites| invites unless invites.status!="accepted"}).reject {|invite| invite.nil?}
    @pending_this_week=(@total_invites_this_week.map {|invites| invites unless invites.status!="pending"}).reject {|invite| invite.nil?}
  end

  def functional_admins_new
    @groups=UserGroup.where status:true
  end

  def functional_admin_edit
    @admin=User.find params[:id]
    @groups=UserGroup.where status:true
    @current_groups=@admin.groupings.map {|group| group.user_group_id}
  end

  def functional_admin_update
    @admin=User.find params[:id]
    @current_groups=@admin.groupings.map {|group| group.user_group_id}
    if @admin.update_attributes(params[:user])
      @admin.update_user_group_mapping(params[:group_ids])
      redirect_to admin_functional_admin_path
    else
      flash[:error]=mapping.errors.full_messages
      render "functional_admins_edit"
    end
  end

  def functional_admin_more
  end

  def functional_admin_index
    @admins=User.where user_role:201
  end

  def create_functional_admin
    begin
    @user=User.find_by_email params[:email] unless params[:email].nil?
    @groups=UserGroup.where status:true
    if !@user.groupings.empty?
      flash[:error]="Functional admin already exists. please edit"
      redirect_to admin_functional_admin_edit_path(:id=>@user.id)
    elsif !@user.nil?
      @groups=params[:group_ids]
      @groups.each do |group|
        mapping=@user.groupings.new(:user_id=>@user.id, :user_group_id=>group)
        if mapping.save
          @user.update_attributes(:user_role=>201)
          redirect_to admin_functional_admin_path and return
        else
          flash[:error]=mapping.erorrs.full_messages
          render "functional_admins_new" and return
        end
      end
    end
    rescue
      flash[:error] = "User with email : #{params[:email]} doesnt exists. Please signup with that email id"
      redirect_to "/admin/functional_admin"
    end
  end

  def more_details
    @abilities=[]
    @admin=User.find params[:id]
    groups=@admin.user_groups
    groups.each do |group|
      @abilities<<group.abilities.map {|ability| ability.name+" - " +ability.remark.to_s}
    end
    @abilities=@abilities.join(",").split(",").uniq
  end

  def invitations
    @total_invites=InvitationHistory.not_rejected
    @total_invites_filtered=@total_invites.map {|history| history.filter_invites }
  end

  def invites_by_user
    @user=User.find params[:id]
    @total_invites=@user.invitation_histories.not_rejected
    @total_invites=@total_invites.map {|history| history.filter_for_user}
  end

  def settings

  end

  def update_settings
    point=Settings.find_by_key "points_earned_per_invite"
    if point.nil?
      Settings.create(:key=>"points_earned_per_invite", :value=>params[:points])
      flash[:notice]="Settings updated"
      redirect_to admin_invitations_path
    else
      if point.update_attributes(:value=>params[:points])
        flash[:notice]="Settings updated"
        redirect_to admin_invitations_path
      else
        flash[:error]=point.errors.full_messages
        render :settings
      end
    end
  end

  def functional_admin_delete
    @user=User.find params[:id]
    @user.groupings.destroy_all
    @user.update_attributes(:user_role=>301)
    redirect_to admin_functional_admin_index_path
  end
end
