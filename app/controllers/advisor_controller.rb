class AdvisorController < ApplicationController
  before_filter :authenticate_user!
  before_filter {|c| c.can_manage(7) }

  caches_action :index, :personal_view, :behaviour_view, :financial_view,
               :risk_profile, :asset_allocation, :view_profiling

  def index
    @users=User.select([:id, :email, :profiling, :created_at]).where advisor_id:current_user.id
  end

  def select_user
    session[:selected_user_id] = params[:id]
    redirect_to advisor_personal_view_path
  end

  def new_user
    @user=User.new
    @user_detail=@user.build_user_detail
  end

  def create_user
    @user=User.new params[:user]
    @user.create_details(current_user.id)
    if @user.save
      expire_action :action => :index
      flash[:notice]="Client added successfully"
      redirect_to advisor_personal_view_path
    else
      flash[:error]=@user.errors.full_messages
      render :new_user
    end
  end

  def personal_edit
    @user=User.find params[:id]
    if !@user.verify_advisor(current_user.id)
      flash[:error]="you dont have enough permissions to edit this user"
      redirect_to advisor_path
    end
    respond_to do |format|
      format.js
    end
  end

  def personal_update
    @user=User.find params[:id]
    if !@user.verify_advisor(current_user.id)
      expire_action :action => :personal_view
      flash[:error]="you dont have enough permissions to edit this user"
      redirect_to advisor_path
    end
    if @user.update_attributes params[:user]
      flash[:notice]="Client updated successfully"
    else
      flash[:error]=@user.errors.full_messages
    end
    redirect_to advisor_personal_view_path
  end

  def personal_view
    begin
      @user=User.find session[:selected_user_id]
    rescue
      flash[:error] = "Please select a user"
      redirect_to advisor_path
    end
  end

  def behaviour_edit
    @survey = RiskQuestionSurvey.all
    expire_action :action => [:behaviour_view, :risk_profile, :asset_allocation]
    respond_to do |format|
      format.js
    end
  end

  def behaviour_view
    begin
      client_id = session[:selected_user_id]
      @answers = current_user.answer_behavior_questions(params,client_id)
      @score = current_user.get_total_risk_score(client_id)
    rescue
      flash[:error] = "Please select a user"
      redirect_to advisor_path
    end
  end

  def financial_edit
    expire_action :action => [:financial_view, :risk_profile, :asset_allocation]
    @total = FinancialProfileQuestion.all
    respond_to do |format|
      format.js
    end
  end

  def financial_view
    begin
      client_id = session[:selected_user_id]
      @response = current_user.answer_financial_questions(params,client_id)
    rescue
      flash[:error] = "Please select a user"
      redirect_to advisor_path
    end
  end

  def risk_profile
    begin
      client_id = session[:selected_user_id]
      @client = User.find client_id
      @behaviour_profile = @client.get_behavior_reports
      @comments = []
      financial_profile = User.get_financial_report(client_id)
      financial_profile.first.each_with_index do |value,index|
        @comments << value if index.even?
      end
    respond_to do |format|
      if params[:name]== @client.user_detail.full_name
        render :pdf => "#{@client.user_detail.full_name}" and return
      elsif params[:format]=="xls"
        format.xls
      else
        format.html
      end
    end
    rescue
      flash[:error] = "Please select a user"
      redirect_to advisor_path
    end
  end

def asset_allocation
    begin
      client_id = session[:selected_user_id]
      @client=User.find client_id
      if params[:name]=="download_excel"
        download_type="excel"
      elsif params[:name]=="#{@client.user_detail.full_name}"
        download_type="pdf"
      else
        download_type="html"
      end
      behavior_score = current_user.get_total_risk_score(client_id)
      financial_score = User.get_financial_report(client_id).last
      score = (behavior_score + financial_score)
	@risk_profile_name = RiskProfile.where("from_mark <= #{score} AND to_mark >= #{score}").first
      @best_in_time_horizon = PortfolioGroup.best_in_time_horizon(score)
      graph_datas = PortfolioGroup.plot_graph(@best_in_time_horizon, download_type)
      if download_type!="excel"
        @pie_chart = graph_datas.first
        @bar_graph = graph_datas[1]
        @portfolio_details = graph_datas.last
        @count = @portfolio_details.count
      end
      respond_to do |format|
        if params[:name]=="#{@client.user_detail.full_name}"
          render :pdf => "#{@client.user_detail.full_name}", :extra=>"--print-media-type" and return
        elsif params[:name] =="download_excel"
          package=PortfolioGroup.generate_excel(graph_datas)
          outstrio = StringIO.new
          package.use_shared_strings = true
          outstrio.write(package.to_stream.read)
          send_data(outstrio.string, :filename=>"#{@client.user_detail.full_name}.xlsx") and return
        else
          format.html
        end
      end
    rescue
      flash[:error] = "Please select a user"
     redirect_to advisor_path and return
    end
  end
  def save_asset_allocation
    portfolios = params[:portfolios]
    begin
      client_id = session[:selected_user_id]
      behavior_score = current_user.get_total_risk_score(client_id)
      if UserProfiler.save_profile(portfolios,client_id)
        expire_action :action => :view_profiling
        flash[:notice] = "Updated"
      else
        flash[:error] = "Please try again"
      end
      redirect_to advisor_path
    rescue
      flash[:error] = "Please select a user"
      redirect_to advisor_path and return
    end
  end

  def view_profiling
    client_id = params[:id]
    @user = UserProfiler.view_profiling(client_id)
  end
end
