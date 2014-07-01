class RiskToleranceController < ApplicationController

  before_filter :authenticate_user!
  before_filter {|c| c.can_manage(4)}

  def index
    @risk_tolerance_level = RiskToleranceLevel.order(:id)
  end

  def new
    @risk_tolerance_level = RiskToleranceLevel.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @risk_tolerance_level = RiskToleranceLevel.new(params[:risk_tolerance_level])
    if @risk_tolerance_level.save
      flash[:notice] = 'Risk Tolerance Level was successfully created.'
    else
      flash[:error] = @risk_tolerance_level.errors.full_messages.to_sentance
    end
    redirect_to admin_investment_risk_tolerance_path
  end

  def edit
    @risk_tolerance_level = RiskToleranceLevel.find params[:id]
  end

  def update
    @risk_tolerance_level = RiskToleranceLevel.find params[:risk_tolerance_level][:id]
    if @risk_tolerance_level.update_attributes params[:risk_tolerance_level]
      flash[:notice] = "Successfully updated..."
    else
      flash[:error] = @risk_tolerance_level.errors.full_messages.to_sentance
    end
    redirect_to admin_investment_risk_tolerance_path
  end

  def destroy
    @risk_tolerance_level = RiskToleranceLevel.find params[:id]
    if @risk_tolerance_level.destroy
      flash[:notice] = "Successfully deleted..."
    else
      flash[:error] = @risk_tolerance_level.errors.full_messages.to_sentance
    end
    redirect_to admin_investment_risk_tolerance_path
  end

  def preview
    @survey = RiskQuestionSurvey.all rescue create_risk_question_survey
    @total = FinancialProfileQuestion.all
  end

  def view_report_behaviour
    $total_score = 0.0
    $comments = []
    survey = RiskQuestionSurvey.find(1) rescue create_risk_question_survey
    @total = Array.new
    @behaviour_score = 0.0
    params.except(:utf8,:authenticity_token,:commit,:method, :action, :controller).each do |key, value|
      @risk_option = RiskQuestionOption.find(value)
      @total << @risk_option.option_comment
      @behaviour_score = @behaviour_score + @risk_option.option_score
    end
    $max_behaviour_score = RiskQuestionOption.sum(:option_score)
    $behaviour_score = @behaviour_score
    $total_score  += @behaviour_score
    $comments << @total
    @score = 0
    @rta_level = "-"
    @risk_profile_name = RiskProfile.where("from_mark <= #{@behaviour_score} AND to_mark >= #{@behaviour_score}").first
    respond_to do |format|
      format.js
    end
  end

  def view_report_finance
    answers = Hash.new { |map_variable, answer|  }
    @financial_profile_questions = FinancialProfileQuestion.all
    p = params.except(:utf8,:authenticity_token,:commit,:method, :action, :controller)
    answers = p.delete_if { |key, value| value.empty? }
    @comments = []
    @score = 0.0

    #liquidity_ratio = cash/expense = (2/1)
    liquidity_ratio =  (answers.values_at('1', '2').compact.length > 1) ? (answers["2"].to_f/answers["1"].to_f) : "Insufficient data to calculate liquidity ratio"
    unless liquidity_ratio.is_a? String
      options = FinanceMeasure.first.finance_measure_options
      get_comments(liquidity_ratio,options,@comments,@score)
    else
      @comments << liquidity_ratio
    end

    #Expense_ratio = Expense/income = (1/3)
    expense_ratio =  (answers.values_at("1", "3").compact.length > 1) ? (answers["1"].to_f/answers["3"].to_f) : "Insufficient data to calculate expense ratio"
    unless expense_ratio.is_a? String
      options = FinanceMeasure.find(2).finance_measure_options
      get_comments(expense_ratio,options,@comments,@score)
    else
      @comments << expense_ratio
    end

    #Loan to income ratio = EMI/income = (4/3)
    loan_to_income_ratio =  (answers.values_at("4", "3").compact.length > 1) ? (answers["4"].to_f/answers["3"].to_f) : " Insufficient data to calculate loan to income ratio"
    unless loan_to_income_ratio.is_a? String
      options = FinanceMeasure.find(3).finance_measure_options
      get_comments(loan_to_income_ratio,options,@comments,@score)
    else
      @comments << loan_to_income_ratio
    end

    #Premium to Income ratio = (premium/(income*12)) = (5/(3*12))
    premium_to_income_ratio =  (answers.values_at("5", "3").compact.length > 1) ? (answers["5"].to_f/(answers["3"].to_f)*12) : "Insufficient data to calculate premium to income ratio"
    unless premium_to_income_ratio.is_a? String
      options = FinanceMeasure.find(4).finance_measure_options
      get_comments(premium_to_income_ratio,options,@comments,@score)
    else
      @comments << premium_to_income_ratio
    end

    #Debt to Asser Ratio = Debts/Assets = (6/7)
    debt_to_asset_ratio =  (answers.values_at("6", "7").compact.length > 1) ? (answers["6"].to_f/answers["7"].to_f) : "Insufficient data to calculate debt to asset ratio"
    unless debt_to_asset_ratio.is_a? String
      options = FinanceMeasure.find(5).finance_measure_options
      get_comments(debt_to_asset_ratio,options,@comments,@score)
    else
      @comments << debt_to_asset_ratio
    end

    #Insurance Cover Ratio = (Sum Assured/(income*12)) = (8/(3*12))
    insurance_cover_ratio =  (answers.values_at("8", "3").compact.length > 1) ? (answers["8"].to_f/(answers["3"].to_f)*12) : "Insufficient data to calculate insurance cover ratio"
    unless expense_ratio.is_a? String
      options = FinanceMeasure.find(6).finance_measure_options
      get_comments(insurance_cover_ratio,options,@comments,@score)
    else
      @comments << insurance_cover_ratio
    end

    #Retirement Ratio = Retirement Savings/Income = (9/3)
    retirement_ratio =  (answers.values_at("9", "3").compact.length > 1) ? (answers["9"].to_f/answers["3"].to_f) : "Insufficient data to calculate retirement ratio"
    unless retirement_ratio.is_a? String
      options = FinanceMeasure.find(7).finance_measure_options
      get_comments(retirement_ratio,options,@comments,@score)
    else
      @comments << retirement_ratio
    end

    #Savings rate ratio = (Income- Expense - EMI - Premium)/Income = ((3-1-4-5)/3)
    savings_rate_ratio =  (answers.values_at("3", "1", "4", "5").compact.length > 1) ? ((answers["3"].to_f - answers["1"].to_f - answers["4"].to_f - answers["5"].to_f)/answers["3"].to_f) : "Insufficient data to calculate savings rate ratio"
    unless savings_rate_ratio.is_a? String
      options = FinanceMeasure.find(8).finance_measure_options
      get_comments(savings_rate_ratio,options,@comments,@score)
    else
      @comments << savings_rate_ratio
    end

    $total_score += @score
    rta_level = RiskToleranceLevel.where("from_value <= #{$total_score} AND to_value >= #{$total_score}").first rescue "Not Found"
    if rta_level.nil?
      @rta_level = "-"
    else
      @rta_level = rta_level.level
    end

    $comments << @comments
    @total_questions_count = @financial_profile_questions.count
    $max_financial_score =  FinanceMeasureOptions.sum(:above_ideal_score)
    $max_total = $max_behaviour_score + $max_financial_score

    respond_to do |format|
      format.js
    end
    #render 'report'
  end

  protected
  def get_comments(ratio,object,comments,score)
    unless object.nil?
      if ratio >= object.above_ideal_from
        comments << object.above_ideal_comment
        @score += object.above_ideal_score.to_i rescue 0
      elsif ratio > object.equal_ideal_from and ratio < object.equal_ideal_to
        comments << object.equal_ideal_comment
        @score += object.equal_ideal_score.to_i rescue 0
      else
        comments << object.below_ideal_comment
        @score += object.below_ideal_score.to_i rescue 0
      end
    end
    return comments,score
  end
end
