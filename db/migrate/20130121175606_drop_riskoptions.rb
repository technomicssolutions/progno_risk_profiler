class DropRiskoptions < ActiveRecord::Migration
  def up
  	drop_table :riskoptions
  end

  def down
  end
end
