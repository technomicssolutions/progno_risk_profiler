class RenameOldTableToNewTable < ActiveRecord::Migration
  def change

  	rename_table :details , :user_details


  end

end
