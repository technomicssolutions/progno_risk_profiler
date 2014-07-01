class SiteContent < ActiveRecord::Base
  attr_accessible :content, :page_url, :published
  validates_presence_of :page_url

  scope :page, lambda { |url| { :conditions => {:published => true, :page_url => url}}}

end
