class DropRiskquestions < ActiveRecord::Migration
  def up
  	 drop_table :riskquestions
  end

  def down
  end
end
