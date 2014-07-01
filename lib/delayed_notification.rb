class DelayedNotification < Struct.new(:email, :invitee,:user_level,:invitation_message)

  def perform
    invite = User.invite!({email:email,user_role:301,user_level:user_level,invitation_message:invitation_message}, invitee)
  end

  def success(invite)
    new_history=invitee.invitation_histories.create(:invited=>invited.id)
  end

  private
  def invited
    invited = User.find_by_email(email)
  end

end
