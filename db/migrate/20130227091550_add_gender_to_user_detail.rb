class AddGenderToUserDetail < ActiveRecord::Migration
  def change
    add_column :user_details, :gender, :string
    add_column :user_details, :marital_status, :string
    add_column :user_details, :image_remote_url, :string
    add_column :user_details, :phone, :string
    add_column :user_details, :location, :string
  end
end
