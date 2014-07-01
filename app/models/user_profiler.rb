class UserProfiler < ActiveRecord::Base
  attr_accessible :efficient_frontier_id, :risk_penalty, :user_id, :utility, :time_horizon
  validates_uniqueness_of :user_id, :scope=>:time_horizon
  belongs_to :user

  def self.save_profile(portfolios,client_id)
    portfolios.each do |portfolio|
      time_horizon = portfolio[0]
      efficient_frontier_id = portfolio[1][0]
      utility = portfolio[1][1]
      efficient_frontier = EfficientFrontier.find efficient_frontier_id
      risk_penalty = 130
      profile = self.find(:first, :conditions=>{user_id:client_id,time_horizon:time_horizon})
      if profile.nil?
        self.create(efficient_frontier_id:efficient_frontier_id,risk_penalty:risk_penalty,utility:utility,user_id:client_id,time_horizon:time_horizon)
      else
        profile.update_attributes(efficient_frontier_id:efficient_frontier_id,risk_penalty:risk_penalty,utility:utility,user_id:client_id)
      end
      User.find(client_id).update_attributes(:profiling=>true)
    end
  end

  def self.view_profiling(client_id)
    self.find(:all, :conditions => {user_id:client_id})
  end

  def efficient_frontier
    efficient_frontier = EfficientFrontier.find(self.efficient_frontier_id)
  end

  def composition
    composition = self.efficient_frontier.composition.split(':')
    value = []
    AssetClass.select([:id,:main_asset_class]).each_with_index do |data,index|
      value << [data.main_asset_class,composition[index].to_i]
    end
    value
  end

  def risk
    self.efficient_frontier.risk
  end

  def return
    self.efficient_frontier.return
  end

  def sharpe_ratio
    self.efficient_frontier.sharpe_ratio
  end

  def risk_free_ratio
    portfolio_group_id = self.efficient_frontier.portfolio_group_id
    portfolio = PortfolioGroup.find portfolio_group_id
    portfolio.risk_free
  end
end
