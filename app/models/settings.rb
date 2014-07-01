class Settings < ActiveRecord::Base
  attr_accessible :key, :value
  validates_presence_of :key
  validates_presence_of :value
end
