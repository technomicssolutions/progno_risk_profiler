class PortfolioGroupAsset < ActiveRecord::Base
  belongs_to :portfolio_group
  belongs_to :asset_class
  attr_accessible :asset_class_id, :name, :maximum, :minimum,:portfolio_group_id
end
