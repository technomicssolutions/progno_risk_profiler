class AddMessageToUser < ActiveRecord::Migration
  def change
    add_column :users, :invitation_message, :text
  end
end
