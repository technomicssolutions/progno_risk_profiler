# Can manage the abilities for various user roles
class AbilityController < ApplicationController

  def index
    @ability = Ability.all
  end

  def edit
    @ability = Ability.find(params[:id])
    @functions=Function.all
    @current_functions=@ability.functions.split(",")
  end

  def new
    @ability = Ability.new
    @functions=Function.all
  end

  def update
    @ability = Ability.find params[:id]
    @functions=Function.all
    @current_functions=@ability.functions.split(",")
    if @ability.update_attributes(params[:ability])
      functions=params[:functions].join(",") if params[:functions]
      if @ability.update_attributes(:functions=>functions)
        flash[:notice] ="Control Updated Succesfully"
        redirect_to admin_users_ability_path
      else
        flash[:error] = @ability.errors.full_messages.to_sentence
        render 'edit'
      end
    else
      flash[:error] = @ability.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  def create
    @ability = Ability.new(params[:ability])
    @functions=Function.all
    functions=params[:functions].join(",") if params[:functions]
    @ability.functions=functions
    if @ability.save
      flash[:notice] ="ability created Succesfully"
      redirect_to admin_users_ability_path
    else
      flash[:error] = @ability.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def delete_or_undelete
    @ability=Ability.find params[:id]
    if @ability.status
      @ability.update_attributes(:status=>false)
      @ability.ability_group_mappings.destroy_all
      redirect_to admin_users_ability_path
    else
      @ability.update_attributes(:status=>true)
      redirect_to admin_users_ability_path
    end
  end

end
