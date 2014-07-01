class UserGroupController < ApplicationController

  before_filter :authenticate_user!
  before_filter   {|c| c.can_manage(2)}

  def index
    @groups=UserGroup.all
  end

  def new
    @group=UserGroup.new
    @abilities=Ability.all
  end

  def create
    @abilities=Ability.all
    @group=UserGroup.new(params[:user_group])
    if !params[:abilities].nil?
      if @group.save
        params[:abilities].each do |ability|
          AbilityGroupMapping.create(:user_group_id=>@group.id, :ability_id=>ability)
        end
        flash[:notice]="User group is created"
        redirect_to admin_users_user_group_path
      else
        flash[:error]=@group.errors.full_messages
        render :new
      end
    else
      flash[:error]="Abilities can't be blank"
      render :new
    end
  end

  def edit
    @group=UserGroup.find params[:id]
    @abilities=Ability.all
    @mapping=@group.ability_group_mappings.map {|ability_mapping| ability_mapping.ability_id }
  end

  def update
    @group=UserGroup.find params[:id]
    @abilities=Ability.all
    @mapping=@group.ability_group_mappings.map {|ability_mapping| ability_mapping.ability_id }
    if @group.update_ability_group_mapping(params[:abilities])
      if @group.update_attributes(params[:user_group])
        flash[:notice]="User group is updated"
        redirect_to admin_users_user_group_path
      else
        flash[:error]=@group.errors.full_messages
        render :edit
      end
    else
      flash[:error]="Abilities can't be blank"
      render :edit
    end
  end

  def delete_or_undelete
    @group=UserGroup.find params[:id]
    if @group.status
      @group.update_attributes(:status=>false)
      @group.groupings.destroy_all
      @group.ability_group_mappings.destroy_all
      redirect_to admin_users_user_group_path
    else
      @group.update_attributes(:status=>true)
      redirect_to admin_users_user_group_path
    end
  end
end
