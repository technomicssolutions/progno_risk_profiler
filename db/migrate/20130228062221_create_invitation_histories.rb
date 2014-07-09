class CreateInvitationHistories < ActiveRecord::Migration
  def change
    create_table :invitation_histories do |t|
      t.integer :user_id
      t.integer :invited
      t.boolean :status, :default=>false

      t.timestamps
    end
  end
end
