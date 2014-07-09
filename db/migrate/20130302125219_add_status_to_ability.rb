class AddStatusToAbility < ActiveRecord::Migration
  def change
    add_column :abilities, :status, :boolean, :default=>true
  end
end
