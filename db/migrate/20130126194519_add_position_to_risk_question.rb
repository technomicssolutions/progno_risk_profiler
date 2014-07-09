class AddPositionToRiskQuestion < ActiveRecord::Migration
  def change
    add_column :risk_questions, :position, :integer
  end
end
