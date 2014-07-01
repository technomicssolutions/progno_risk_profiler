class RiskProfileController < ApplicationController


  before_filter :authenticate_user!
  before_filter {|c| c.can_manage(4)}

  caches_action :index, :view_questionaire

  def index
    @risk_questions = RiskQuestion.order(:position)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new_questions
    @risk_question = RiskQuestion.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @risk_question = RiskQuestion.new(params[:risk_question])
    @risk_question.position = (RiskQuestion.all.count + 1)
    respond_to do |format|
      if @risk_question.save
        expire_action :action => [:index, :view_questionaire]
        flash[:notice] = 'Riskquestions was successfully created.'
        format.html { redirect_to admin_investment_risk_profile_path }
      else
        flash[:error] = "#{@risk_question.errors.full_messages.to_sentence}"
        format.html { render action: "new" }
      end
    end
  end

  def set_risk_profile
    @current_risk_profiles = RiskProfile.all
  end

  def new_risk_profile
    @risk_profile = RiskProfile.new
    respond_to do |format|
      format.js
    end
  end

  def save_risk_profile
    @risk_profile = RiskProfile.new(params[:risk_profile])

    respond_to do |format|
      if @risk_profile.save
        flash[:notice] = 'Riskprofile was successfully created.'
        format.html { redirect_to admin_risk_profile_set_risk_profile_path }
      else
        flash[:error] = "#{@risk_profile.errors.full_messages.to_sentence}"
        wants.html { render :action => "new" }
      end
    end
  end

  def view_questionaire
    @survey = RiskQuestionSurvey.all rescue create_risk_question_survey
  end

  def view_report
    survey = RiskQuestionSurvey.find(1) rescue create_risk_question_survey
    @total = Array.new
    score = 0
    params.except(:utf8,:authenticity_token,:commit,:method, :action, :controller).each do |key, value|
      @risk_option = RiskQuestionOption.find(value)
      @total << @risk_option.option_comment
      risk_score = (@risk_option.option_score.nil? ? 0 : @risk_option.option_score)
      score = score + risk_score
    end
    @total_questions_count = RiskQuestionOption.all.count
    @max_score = RiskQuestionOption.sum(:option_score)
    @risk_profile_name = RiskProfile.where("from_mark <= #{score} AND to_mark >= #{score}").first
    respond_to do |format|
      format.js
    end
  end

  def edit_question
    @risk_question = RiskQuestion.find params[:id]
    respond_to do |format|
      format.js
    end
  end

  def update_question
    @risk_questions = RiskQuestion.find params[:risk_question][:id]
    params[:risk_question].delete(:id)
    if @risk_questions.update_attributes params[:risk_question] then
      expire_action :action => [:index, :view_questionaire]
      flash[:notice] = "Question Sucessfully Edited"
      redirect_to admin_investment_risk_profile_path and return
    else
      flash[:error] = "#{@risk_questions.errors.full_messages.to_sentence}"
      render 'edit'
    end
  end

  def destroy
    @risk_questions = RiskQuestion.find params[:id]
    if @risk_questions.destroy then
      flash[:notice] = "Deleted"
      expire_action :action => [:index, :view_questionaire]
    else
      flash[:notice] = "Not Deleted"
    end
    redirect_to admin_investment_risk_profile_path and return
  end

  def delete_option
    @risk_question_option = RiskQuestionOption.find params[:id]
    if @risk_question_option.destroy then
      flash[:notice] = "Deleted"
      expire_action :action => [:index, :view_questionaire]
    else
      flash[:notice] = "Not Deleted"
    end
    redirect_to admin_investment_risk_profile_path and return
  end

  def add_option
    @risk_question_option = RiskQuestionOption.new
    @question_id = params[:id]
  end

  def create_option
    @risk_question_option = RiskQuestionOption.new params[:risk_question_option]
    if @risk_question_option.save
      flash[:notice] = "Saved"
      expire_action :action => [:index, :view_questionaire]
    else
      flash[:error] = "Failed to save"
    end
    redirect_to admin_investment_risk_profile_path and return
  end

  def edit_option
    @risk_question_option = RiskQuestionOption.find params[:id]
    respond_to do |format|
      format.js
    end
  end

  def update_option
    @risk_question_option = RiskQuestionOption.find params[:risk_question_option][:id]
    if @risk_question_option.update_attributes params[:risk_question_option]
      flash[:notice] = "Updated"
      expire_action :action => [:index, :view_questionaire]
      redirect_to admin_investment_risk_profile_path
    else
      flash[:error] = " Failed to update"
      redirect_to admin_investment_risk_profile_path
    end
  end

  def sort_position
    survey = RiskQuestionSurvey.first
    risk_questions = survey.risk_questions
    risk_questions.each do |qrisk_questions|
      risk_questions.position = params['risk_questions'].index(risk_questions.id.to_s) + 1
      expire_action :action => [:index, :view_questionaire]
      risk_questions.save
    end
    render :nothing => true
  end

  def sequence_change
    @risk_questions = RiskQuestion.order(:position)
  end

  def sort
    position = params[:order]
    position.each_with_index do |value, index|
      @risk_question = RiskQuestion.find(value.to_i)
      @risk_question.position = (index+1)
      @risk_question.save
    end
    redirect_to '/admin/risk_profile/sequence_change'
  end

  protected
  def create_risk_question_survey
    survey = RiskQuestionSurvey.new
    survey.id = 1
    survey.name = "Riskquestion Survey"
    survey.save
    survey

  end

end
