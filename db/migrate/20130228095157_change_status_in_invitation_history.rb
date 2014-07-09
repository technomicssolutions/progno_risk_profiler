class ChangeStatusInInvitationHistory < ActiveRecord::Migration
  def up
  	change_column :invitation_histories, :status, :string, :default=>"pending"
  end

  def down
  	change_column :invitation_histories, :status, :boolean, :default=>false
  end
end