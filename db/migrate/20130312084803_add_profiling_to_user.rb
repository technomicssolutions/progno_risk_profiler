class AddProfilingToUser < ActiveRecord::Migration
  def change
  	add_column :users, :advisor_id, :integer
  	add_column :users, :profiling, :boolean, :default=>false
  	add_column :user_details, :state, :string
  	add_column :user_details, :country, :string
  end
end
