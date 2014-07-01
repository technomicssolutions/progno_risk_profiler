class FinancialProfileController < ApplicationController

  before_filter :authenticate_user!
  before_filter {|c| c.can_manage(4)}

  caches_action :index, :measure_options, :trial

  def new
    @financialProfileQuestion = FinancialProfileQuestion.new
    @map_variable = MapVariable.all
    respond_to do |format|
      format.js
    end
  end

  def index
    @financialProfileQuestion = FinancialProfileQuestion.all
  end

  def destroy
    @financialProfileQuestion = FinancialProfileQuestion.find params[:id]
    if @financialProfileQuestion.destroy then
      flash[:notice] = "Deleted"
      expire_action :action => [:index, :measure_options, :trial]
    else
      flash[:notice] = "Not Deleted"
    end
    redirect_to '/admin/investment/financial_profile' and return
  end

  def edit
    @financialProfileQuestion = FinancialProfileQuestion.find params[:id]
    @map_variable = MapVariable.all
    respond_to do |format|
      format.js
    end
  end

  def update
    @financialProfileQuestion = FinancialProfileQuestion.find params[:financial_profile_question][:id]
    if @financialProfileQuestion.update_attributes params[:financial_profile_question] then
      expire_action :action => [:index, :measure_options, :trial]
      flash[:notice] = "Question Sucessfully Edited"
      redirect_to '/admin/investment/financial_profile'
    else
      flash[:error] = "#{@financialProfileQuestion.errors.full_messages.to_sentence}"
      redirect_to '/admin/investment/financial_profile'
    end
  end

  def create
    @financialProfileQuestion = FinancialProfileQuestion.new params[:financial_profile_question]
    if @financialProfileQuestion.save then
      expire_action :action => [:index, :measure_options, :trial]
      flash[:notice] = "Question Sucessfully Added"
      redirect_to '/admin/investment/financial_profile'
    else
      flash[:error] = "#{@financialProfileQuestion.errors.full_messages.to_sentence}"
      redirect_to '/admin/investment/financial_profile'
    end
  end

  def measure_options
    @finance_measure_options = FinanceMeasureOptions.all
    @measures = FinanceMeasure.all
    @measure_options_new = FinanceMeasureOptions.new
  end

  def measure_options_new
    @finance_measure_options = FinanceMeasureOptions.new params[:finance_measure_options]
    if @finance_measure_options.save
      flash[:notice] = "Successfully saved..."
    else
      flash[:error] = @finance_measure_options.errors.full_messages.to_sentence
    end
    redirect_to '/admin/investment/financial_profile_analytics'
  end

  def measure_options_edit
    @finance_measure = FinanceMeasure.all
    @finance_measure_options = FinanceMeasureOptions.find params[:id]
    respond_to do |format|
      format.js
    end
  end

  def measure_options_update
    @finance_measure_options = FinanceMeasureOptions.find params[:finance_measure_options][:id]
    if @finance_measure_options.update_attributes params[:finance_measure_options]
      expire_action :action => [:index, :measure_options, :trial]
      flash[:notice] = "Successfully updated..."
    else
      flash[:error] = @finance_measure_options.errors.full_messages.to_sentence
    end
    redirect_to '/admin/investment/financial_profile_analytics'
  end

  def measure_options_destroy
    @finance_measure_options = FinanceMeasureOptions.find params[:id]
    if @finance_measure_options.destroy then
      expire_action :action => [:index, :measure_options, :trial]
      flash[:notice] = "Deleted"
    else
      flash[:notice] = "Not Deleted"
    end
    redirect_to '/admin/investment/financial_profile_analytics'
  end

  def trial
    @total = FinancialProfileQuestion.all
  end

  def trial_calculate
    @comments = FinanceMeasureOptions.finance_profile_try(params)
    @total_questions_count = FinanceMeasureOptions.total_questions_count
    @maximum_score = FinanceMeasureOptions.maximum_score
    @score =
    respond_to do |format|
      format.js
    end
  end

  protected

  def create_financial_profile_survey
    object = FinanceProfileSurvey.new
    object.id = 1
    object.save
    object
  end
end
