class AddUidToInvitationHistory < ActiveRecord::Migration
  def change
    add_column :invitation_histories, :uid, :string
  end
end
