class Usermailer < ActionMailer::Base
  default from: "Progno"
  def invitation_accepted_alert(to,accepted_by)
    @accepted_by=accepted_by
    @sent_by=to
    mail(:from=> "Progno", :to => to.email, :subject => "Your invitation to Progno is accepted", :template_path =>'users', :template_name=>'send_accepted_alert')
  end

  def invitation_rejected_alert(to,rejected_by)
    @rejected_by=rejected_by
    mail(:from=> "Progno", :to => to, :subject => "You have invited an existing member", :template_path =>'users', :template_name=>'send_rejected_alert')
  end
end
