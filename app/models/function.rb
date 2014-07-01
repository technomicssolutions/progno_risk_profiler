class Function < ActiveRecord::Base
  attr_accessible :description, :name
  validates_uniqueness_of :name
  validates_presence_of :name
end
