class AddAttachmentImageToUserDetails < ActiveRecord::Migration
  def self.up
    change_table :user_details do |t|
      t.has_attached_file :image
    end
  end

  def self.down
    drop_attached_file :user_details, :image
  end
end
