class InvitationHistory < ActiveRecord::Base
  attr_accessible :invited, :status, :user_id, :uid
  belongs_to :user
  validates_uniqueness_of :invited, :scope=>:user_id, :unless => Proc.new { |invite| invite.invited == nil }
  validates_uniqueness_of :user_id, :scope => :uid
  scope :not_rejected, find(:all,:conditions=>['status!=?',"rejected"])
  def filter_invites
    [self.user_id, self.user.email, (User.find self.invited).email, self.updated_at, self.status]
  end
  def filter_for_user
    [(User.find self.invited).email, self.updated_at, self.status]
  end
end
