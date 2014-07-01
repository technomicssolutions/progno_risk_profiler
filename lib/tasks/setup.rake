namespace :setup do
	desc "Add a admin user." 
	task :admin => :environment do
		admin= User.new 
		admin.email='admin@admin.com'
		admin.password='admin123'
		admin.password_confirmation='admin123'
		
		print "Admin email: "
		inp=STDIN.gets.strip
		admin.email=inp unless inp.blank?

		print "Admin password: "
		inp=STDIN.gets.strip
		admin.password=inp unless inp.blank?
		admin.password_confirmation=inp unless inp.blank?

		print "Admin First Name:"
		inp=STDIN.gets.strip
		first_name = inp unless inp.blank?

		print "Admin Second Name:"
		inp = STDIN.gets.strip
		second_name = inp unless inp.blank?

		print "Admin Phone Number:"
		inp = STDIN.gets.strip
		phone_number = inp unless inp.blank?

		print "Admin Date of Birth [Enter Format:YYYY-mm-dd]"
		inp = STDIN.gets.strip
		date_of_birth = inp unless inp.blank?					
		
		admin.user_role = 101
		admin.user_level = 1
		admin.skip_confirmation!
				
		if admin.save 
			admin_user_detail = UserDetail.new
			admin_user_detail.first_name = first_name
			admin_user_detail.second_name = second_name
			admin_user_detail.phone = phone_number
			admin_user_detail.date_of_birth = date_of_birth 
			admin_user_detail.user_id=admin.id
		 	admin_user_detail.save
			puts "added admin user"
		else
			puts "failed to add admin"
			puts admin.errors.full_messages.to_s
			puts admin_user_detail.errors.full_messages.to_s
		end
	end	

	desc "Add functions" 
	task :functions => :environment do	
		f="functional admin module,user admin module,invitations module,investment module,faq module,content management module, advisor".split(",")
 		desc="can manage functional admins,can manage users and groups,can manage invitations,can manage investments,can manage frequently asked questions,can manage website contents, can manage advisor module".split(",")
 		(0..6).each do |c|
 			Function.create(:name=>f[c], :description=>desc[c])
 			puts "==created=="+f[c]
 		end
 	end

end
	 
