class FrequentlyAskedQuestion < ActiveRecord::Base
  attr_accessible :answers, :publish, :question , :category_id
  belongs_to :question_categories
  validates_presence_of :question, :answers , :message => "Fields cant be Empty !!"
  scope :published , where(publish: true)
  scope :unpublished , where(publish: false)
end
