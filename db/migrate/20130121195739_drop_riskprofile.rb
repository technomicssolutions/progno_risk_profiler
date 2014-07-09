class DropRiskprofile < ActiveRecord::Migration
  def up
  	drop_table :riskprofiles
  end

  def down
  end
end
