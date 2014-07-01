class UserDetail < ActiveRecord::Base
  attr_accessible :address, :company_details, :company_name, :date_of_birth, :designation, :first_name, :second_name, :user_id, :image, :gender, :marital_status, :image_remote_url, :phone, :location, :state, :country

  validates_presence_of :first_name , :second_name , :date_of_birth , :phone , :message => "Please Fill the required fields inorder to move further"
  validates_format_of :first_name, :second_name ,  :with =>/^[a-zA-Z]*$/
  validates_format_of :phone , :with =>/^[0-9]{10,11}$/
  validates_format_of :date_of_birth ,:with=> /^([0-9]{4})-([0-9]{2})-([0-9]{2})$/
  validates_presence_of :designation
  validates_presence_of :address
  has_attached_file :image ,:default_url => "/images/missing.jpg"
  belongs_to :user

  def full_name
    self.first_name + ' ' +self.second_name
  end
end
