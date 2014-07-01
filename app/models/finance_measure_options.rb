class FinanceMeasureOptions < ActiveRecord::Base
  belongs_to :finance_measures
  attr_accessible :above_ideal_from,:above_ideal_to,:finance_measure_id, :above_ideal_score, :above_ideal_comment, :equal_ideal_from, :equal_ideal_to, :equal_ideal_score, :equal_ideal_comment, :below_ideal_from, :below_ideal_to, :below_ideal_score, :below_ideal_comment
  validates :finance_measure_id, uniqueness: true
  before_save :validate_range

  validates_presence_of :equal_ideal_score, :equal_ideal_from, :equal_ideal_to

  def validate_range
    self.above_ideal_from  = self.above_ideal_from ? self.above_ideal_from : self.equal_ideal_to
    self.below_ideal_to = self.below_ideal_to ? self.below_ideal_to : self.equal_ideal_from
  end

  def self.finance_profile_try(params)
    financial_profile_questions = FinancialProfileQuestion.all
    p = params.except(:utf8,:authenticity_token,:commit,:method, :action, :controller)
    answers = p.delete_if { |key, value| value.empty? }
    comments = []
    score = 0
    #liquidity_ratio = cash/expense = (2/1)
    liquidity_ratio =  (answers.values_at('1', '2').compact.length > 1) ? (answers["2"].to_f/answers["1"].to_f) : "Insufficient data to calculate liquidity ratio"
    unless liquidity_ratio.is_a? String
      options = FinanceMeasure.first.finance_measure_options
      response = get_comments(liquidity_ratio,options,comments,score)
      score = response.last
      comments << response.pop
    else
      comments << liquidity_ratio
    end

    #Expense_ratio = Expense/income = (1/3)
    expense_ratio =  (answers.values_at('1', '3').compact.length > 1) ? (answers["1"].to_f/answers["3"].to_f) : "Insufficient data to calculate expense ratio"
    unless expense_ratio.is_a? String
      options = FinanceMeasure.find(2).finance_measure_options
      response = get_comments(liquidity_ratio,options,comments,score)
      score = response.last
      comments << response.pop
    else
      comments << expense_ratio
    end

    #Loan to income ratio = EMI/income = (4/3)
    loan_to_income_ratio =  (answers.values_at('4', '3').compact.length > 1) ? (answers["4"].to_f/answers["3"].to_f) : " Insufficient data to calculate loan to income ratio"
    unless loan_to_income_ratio.is_a? String
      options = FinanceMeasure.find(3).finance_measure_options
      response = get_comments(liquidity_ratio,options,comments,score)
      score = response.last
      comments << response.pop
    else
      comments << loan_to_income_ratio
    end

    #Premium to Income ratio = (premium/(income*12)) = (5/(3*12))
    premium_to_income_ratio =  (answers.values_at('5', '3').compact.length > 1) ? (answers["5"].to_f/(answers["3"].to_f)*12) : "Insufficient data to calculate premium to income ratio"
    unless premium_to_income_ratio.is_a? String
      options = FinanceMeasure.find(4).finance_measure_options
      response = get_comments(liquidity_ratio,options,comments,score)
      score = response.last
      comments << response.pop
    else
      comments << premium_to_income_ratio
    end

    #Debt to Asser Ratio = Debts/Assets = (6/7)
    debt_to_asset_ratio =  (answers.values_at('6', '7').compact.length > 1) ? (answers["6"].to_f/answers["7"].to_f) : "Insufficient data to calculate debt to asset ratio"
    unless debt_to_asset_ratio.is_a? String
      options = FinanceMeasure.find(5).finance_measure_options
      response = get_comments(liquidity_ratio,options,comments,score)
      score = response.last
      comments << response.pop
    else
      comments << debt_to_asset_ratio
    end

    #Insurance Cover Ratio = (Sum Assured/(income*12)) = (8/(3*12))
    insurance_cover_ratio =  (answers.values_at('8', '3').compact.length > 1) ? (answers["8"].to_f/(answers["3"].to_f)*12) : "Insufficient data to calculate insurance cover ratio"
    unless expense_ratio.is_a? String
      options = FinanceMeasure.find(6).finance_measure_options
      response = get_comments(liquidity_ratio,options,comments,score)
      score = response.last
      comments << response.pop
    else
      comments << insurance_cover_ratio
    end

    #Retirement Ratio = Retirement Savings/Income = (9/3)
    retirement_ratio =  (answers.values_at('9', '3').compact.length > 1) ? (answers["9"].to_f/answers["3"].to_f) : "Insufficient data to calculate retirement ratio"
    unless retirement_ratio.is_a? String
      options = FinanceMeasure.find(7).finance_measure_options
      response = get_comments(liquidity_ratio,options,comments,score)
      score = response.last
      comments << response.pop
    else
      comments << retirement_ratio
    end

    #Savings rate ratio = (Income- Expense - EMI - Premium)/Income = ((3-1-4-5)/3)
    savings_rate_ratio =  (answers.values_at('3', '1', '4', '5').compact.length > 1) ? ((answers["3"].to_f - answers["1"].to_f - answers["4"].to_f - answers["5"].to_f)/answers["3"].to_f) : "Insufficient data to calculate savings rate ratio"
    unless savings_rate_ratio.is_a? String
      options = FinanceMeasure.find(8).finance_measure_options
      response = get_comments(liquidity_ratio,options,comments,score)
      score = response.last
      comments << response.pop
    else
      comments << savings_rate_ratio
    end
    return comments,score
  end

  def self.total_questions_count
    return FinancialProfileQuestion.count
  end

  def self.maximum_score
    return self.sum(:above_ideal_score)
  end

  def self.get_comments(ratio,object,comments,score)
    unless object.nil?
      if ratio >= object.above_ideal_from
        comments << object.above_ideal_comment
        score += object.above_ideal_score.to_i rescue 0
      elsif ratio > object.equal_ideal_from and ratio < object.equal_ideal_to
        comments << object.equal_ideal_comment
        score += object.equal_ideal_score.to_i rescue 0
      else
        comments << object.below_ideal_comment
        score += object.below_ideal_score.to_i rescue 0
      end
    end
    return comments,score
  end

end
