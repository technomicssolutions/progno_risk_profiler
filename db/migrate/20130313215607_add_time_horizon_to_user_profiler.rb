class AddTimeHorizonToUserProfiler < ActiveRecord::Migration
  def change
    add_column :user_profilers, :time_horizon, :integer
  end
end
