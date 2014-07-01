class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable,:invitable, :validatable, :confirmable,  :lockable, :omniauthable, :omniauth_providers => [:facebook, :linkedin, :google]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :user_points,:remember_me ,:user_level , :user_role, :provider, :uid, :invitation_message, :invited_by_id, :invitation_accepted_at, :user_detail_attributes, :advisor_id, :profiling
  has_many :groupings, :dependent => :destroy
  has_many :user_groups, :through => :groupings
  has_one :user_detail
  has_many :invitations, :class_name => self.to_s, :as => :invited_by
  has_many :invitation_histories, :class_name=> 'InvitationHistory'
  has_many :user_risk_profiles
  has_many :user_financial_profiles
  accepts_nested_attributes_for :user_detail
  has_many :user_profiler

  include DeviseInvitable::Inviter

  def bulk_invite(email_ids,invitee,invitation_message)
    invites_unsuccess = []
    invites_success = []
    email_ids.split(",").each do |email|
      if invite_if_valid(email.strip,invitee,invitation_message)
        invites_success << email.strip
      else
        invites_unsuccess << email.strip
      end
    end
    return [invites_success, invites_unsuccess]
  end


  require 'delayed_notification.rb'
  def invite_if_valid(email_id,invitee,invitation_message="Invitation to Progno website")
    if email_id =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      user_level = invitee.user_level.to_i + 1
      Delayed::Job.enqueue DelayedNotification.new(email_id,invitee,user_level,invitation_message)
      return true
    else
      return false
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:email=>auth.info.email).first unless User.first.nil?
    unless user
      user = User.new(provider:auth.provider,
                      uid:auth.uid,
                      email:auth.info.email,
                      password:Devise.friendly_token[0,20]
                      )
      user.skip_confirmation!
      user.save!
    end
    user
  end

  after_invitation_accepted :set_role_points_to_user

  def set_role_points_to_user
    invitee = User.find self.invited_by_id
    invited = self
    point= Settings.find_by_key("points_earned_per_invite").try(:value)
    point ||= 10
    invitee_user_points = invitee.user_points.to_i + point.to_i
    invitee.update_attributes(user_points:invitee_user_points)
    invitee.invitation_histories.find(:first, :conditions=>['invited=?', self.id]).update_attributes(:status=>"accepted")
    set_rejected_histories
    invitee.send_email_update(invited.email)
    UserDetail.create(:user_id=>self.id)
  end

  def set_rejected_histories
    rejected_list=InvitationHistory.find(:all, :conditions=>['invited=? AND status=?', self.id, "pending"])
    rejected_list.each do |rejected|
      rejected.update_attributes(:status=>"rejected")
      Usermailer.delay.invitation_rejected_alert(rejected.user.email,self.email)
    end
  end

  def invitation_accepted
    User.find(:all, :order=>'id DESC', :limit=>10, :conditions=>['invitation_accepted_at IS NOT NULL AND invited_by_id=?', self.id])
  end

  def invitation_not_accepted
    histories=self.invitation_histories.where(:status=>"pending").order('updated_at DESC' ).limit(10)
    users=[]
    histories.each do |history|
      users<<User.find(history.invited) rescue User.find_by_uid(history.uid)
    end
    users
  end

  def invites_accepted_full
    User.find(:all, :conditions=>['invitation_accepted_at IS NOT NULL AND invited_by_id=?', self.id])
  end

  def invites_not_accepted_full
    User.find(:all, :conditions=>['invitation_accepted_at IS NULL AND invited_by_id=?', self.id])
  end

  def send_email_update(accepted_by)
    Usermailer.delay.invitation_accepted_alert(self,accepted_by)
  end

  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)
    user = User.where(:email=>auth.info.email).first unless User.first.nil?
    unless user
      user = User.new(provider:auth.provider,
                      uid:auth.uid,
                      email:auth.info.email,
                      password:Devise.friendly_token[0,20]
                      )
      user.skip_confirmation!
      user.save!
    end
    user
  end

  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first unless User.first.nil?
    unless user
      user = User.new(provider:access_token.provider,
                      uid:access_token.uid,
                      email:data.email,
                      password:Devise.friendly_token[0,20]
                      )
      user.skip_confirmation!
      user.save!
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def make_info_fb(hash)
    user_info={:provider=>hash.provider,
               :first_name=>hash.info.first_name,
               :last_name=>hash.info.last_name,
               :location=>hash.info.location,
               :designation=> hash.try(:extra).try(:raw_info).try(:work[0]).try(:position).try(:name),
               :profile_pic_url=>hash.info.image,
               :employer=>hash.try(:extra).try(:raw_info).try(:work[0]).try(:employer).try(:name),
               :gender=>hash.try(:extra).try(:raw_info).try(:gender),
               :phone=>hash.info.phone
               }

    user_info
  end

  def make_info_linkedin(hash)
    user_info={:provider=>hash.provider,
               :first_name=>hash.info.first_name,
               :last_name=>hash.info.last_name,
               :location=>hash.info.location,
               :phone=>hash.info.phone,
               :designation=> hash.info.description,
               :profile_pic_url=>hash.info.image
               }
    user_info
  end

  def make_info_google(hash)
    user_info={:provider=>hash.provider,
               :first_name=>hash.info.first_name,
               :last_name=>hash.info.last_name,
               :location=>hash.info.location,
               :designation=> hash.info.description,
               :profile_pic_url=>hash.info.image,
               :phone=>hash.info.phone
               }
    user_info
  end

  def get_details_fb(info)
    @user_details = self.user_detail
    @user_details.first_name= info[:first_name]
    @user_details.second_name= info[:last_name]
    @user_details.location= info[:location]
    @user_details.phone=info[:phone]
    @user_details.gender=info[:gender]
    @user_details.company_name=info[:employer]
    @user_details.designation= info[:designation]
    @user_details.image_remote_url=info[:profile_pic_url]
    @user_details
  end

  def get_details_linkedin(info)
    @user_details = self.user_detail
    @user_details.first_name= info[:first_name]
    @user_details.second_name= info[:last_name]
    @user_details.location= info[:location]
    @user_details.designation= info[:designation]
    @user_details.image_remote_url=info[:profile_pic_url]
    @user_details
  end

  def get_details_google(info)
    @user_details = self.user_detail
    @user_details.first_name= info[:first_name]
    @user_details.second_name= info[:last_name]
    @user_details.location= info[:location]
    @user_details.image_remote_url=info[:profile_pic_url]
    @user_details
  end

  def update_user_group_mapping(groups)
    current_groups=self.groupings.map {|group| group.id}
    current_groups.each do |group|
      if !groups.member?group
        Grouping.destroy group
      end
    end
    current_groups=self.groupings.map {|group| group.user_group_id}
    groups.each do |group|
      if !current_groups.member?group
        Grouping.create(:user_id=>self.id, :user_group_id=>group)
      end
    end
  end

  def facebook_invite(user_ids)
    user_ids.map{|user_id| self.invitation_histories.create(user_id:self.id,uid:user_id,status:"pending")}
  end

  def complete_facebook_invitation
    uid = self.uid
    last_invitation = InvitationHistory.find(:last, :conditions=>{uid:uid,status:"pending"})
    if last_invitation
      last_invitation.update_attributes(status:"accepted",invited:self.id)
      invitation_histories = InvitationHistory.where(uid:uid,status:"pending")
      invitation_histories.map{|invite| invite.update_attributes(status:"rejected",invited:self.id)}
      invitee_id = last_invitation.user_id
      self.update_attributes(invited_by_id:invitee_id,invitation_accepted_at:Time.now.to_datetime)
      invitee = User.find(invitee_id)
      user_points = Settings.find_by_key("points_earned_per_invite").try(:value)
      user_points ||= 10
      invitee.update_attributes(user_points:user_points)
    end
  end

  def create_details(advisor_id)
    self.skip_confirmation!
    self.password=Devise.friendly_token.first(6)
    self.advisor_id=advisor_id
  end

  def verify_advisor(advisor_id)
    if self.advisor_id==advisor_id
      return true
    else
      return false
    end
  end

  #get a total score of a users behavior questions based on answers submitted
  def get_total_risk_score(client)
    client = User.find client
    scores=client.user_risk_profiles.map {|profile| (RiskQuestionOption.find profile.risk_question_option_id).option_score}
    scores.sum
  end

  def answer_behavior_questions(params,client_id)
    score = 0
    client = User.find client_id
    #will get the questions and answers in params
    params.except(:utf8,:authenticity_token,:commit,:method, :action, :controller).each do |key, value|
      #check if already answered
      unless (client.user_risk_profiles.where risk_question_id:key.to_i).exists?
        UserRiskProfile.create(:user_id=>client_id, :risk_question_id=>key.to_i, :risk_question_option_id=>value.to_i)
      else
        #update answers
        answers=(client.user_risk_profiles.find(:first, :conditions => { risk_question_id:key.to_i}))
        answers.update_attributes(:risk_question_option_id=>value.to_i)
      end
    end
    #fetch questions, answers and its comments
    user_risk_profiles=client.get_behavior_answers
  end

  #get answers and its comments for behavior question answered by a user
  def get_behavior_answers
    self.user_risk_profiles.map {|profile| [(RiskQuestion.find profile.risk_question_id).risk_question, (RiskQuestionOption.find profile.risk_question_option_id).option_name]}
  end

  def get_behavior_reports
    self.user_risk_profiles.map {|profile| (RiskQuestionOption.find profile.risk_question_option_id).option_comment}
  end

  def answer_financial_questions(params,client_id)
    client = User.find client_id
    p = params.except(:utf8,:authenticity_token,:commit,:method, :action, :controller)
    #store answers
    map_variables = p.delete_if { |key, value| value.empty? }
    #process the answers and get comments
    comments = FinanceMeasureOptions.finance_profile_try(params)
    map_variables.each do |key, value|
      unless client.user_financial_profiles.where(finance_measure_id:key.to_i).exists?
        answers = UserFinancialProfile.create(user_id:client_id,finance_measure_id:key.to_i,finance_measure_value:value.to_i)
      else
        previous_answer = client.user_financial_profiles.find(:first,:conditions=>{finance_measure_id:key.to_i})
        answers = previous_answer.update_attributes(finance_measure_value:value.to_i)
      end
    end
    answers = User.get_financial_answers(client_id)
  end

  def self.get_financial_answers(client_id)
    answers = UserFinancialProfile.find(:all, :conditions=> {user_id:client_id}).map{|x| [x.finance_measure_id,x.finance_measure_value]}
    answers.map{|x| [FinancialProfileQuestion.select([:question, :map_variable_id]).where(:map_variable_id=>x[0]),x[1]]}
  end

  def self.get_financial_report(client_id)
    answers = UserFinancialProfile.find(:all, :conditions=> {user_id:client_id}).map{|x| [x.finance_measure_id,x.finance_measure_value.to_s]}
    params = Hash[answers].stringify_keys
    comments = FinanceMeasureOptions.finance_profile_try(params)
    return comments
  end

end
