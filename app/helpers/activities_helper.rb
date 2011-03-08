module ActivitiesHelper
# returnes a user object. 
#If the user does no exists, it creates a skeloton of an inactive user
# returns nil if email is invalid 

  def user_by_email (email)
  	if(email != nil && !email.empty? )
		puts "------------------ adding new invitee: " + email 
	  	user  = User.find_by_email(email)
	  	if(user == nil)
	#create an inactive user
			config.debug("--->>> creating a skeloton user for email: "+email)
			params = {:name => "not active",:email => email, :password => "111111",:password_confirmation => "111111"}
			
	#ilan: using temporary password. Deactivated user should not have passwords	
			puts "------------------ creating new user: " + email 
			
			user = User.create(params)
			user.deactivate_user
	# ilan: missign error handling
	  	end  	
  end
  return user
  
 end

###################################################### 
# add participants to activity 
######################################################

  def  add_activity_participants(emails, activity) 
#in the furue we need to parse a list of users
  	
  	invitees = emails.split (',')
  	
  	puts "#######################################################"
  	puts invitees.inspect
  	puts "#######################################################"
  	
  	invitees.each do |email_address|
  	
    	
	   	if (email_address != nil && !email_address.empty?)
	    	user = user_by_email(email_address.strip)
	    	if(user !=nil)
	   			activity.add_user_invitee(user)
	   			
	   		end
		end		
	end 
	activity.save
	
  end
  
#convert year/month/day to one string
   def  convert_date_to_string (params, parameter_name) 
   	puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  " + parameter_name 
  	puts params.inspect	
   	if(params[parameter_name].instance_of? String)
   			if(params[parameter_name] == nil || params[parameter_name].empty?)
   				return ""
   			end
   			date = params[parameter_name].split ('-')
   			puts date.inspect
   			params[parameter_name]= {"year"  => date[2],
   									 "month" => date[0],
   									 "day"	 => date[1]}
   	end
   	due = Time.local(params[parameter_name]["year"],params[parameter_name]["month"],params[parameter_name]["day"]).inspect		
    return due
    	 
   end
# replace activity 
   def  update_activity_participants_by_email (emails, activity) 
#in the furue we need to parse a list of users
    activity.clean_user_invitees	
  	add_activity_participants(emails, activity)
  	
   end
   
     
end
