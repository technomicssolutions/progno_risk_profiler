class QuestionCategory < ActiveRecord::Base
  attr_accessible :image_url, :name  ,:image
  has_many :frequently_asked_questions , :foreign_key => "category_id" , :dependent => :destroy

  has_attached_file :image

end
