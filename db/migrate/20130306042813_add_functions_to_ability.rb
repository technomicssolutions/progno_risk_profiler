class AddFunctionsToAbility < ActiveRecord::Migration
  def change
    add_column :abilities, :functions, :string
  end
end
