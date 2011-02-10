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
  	
  	invitees = emails.split (';')
  	
  	puts "#######################################################"
  	puts invitees.inspect
  	puts "#######################################################"
  	
  	invitees.each do |email_address|
  	
  	puts "#######################################################"
  	puts "adding user: " + email_address
  	puts "#######################################################"
  	
	   	if (email_address != nil && !email_address.empty?)
	    	user = user_by_email(email_address.strip)
	    	if(user !=nil)
	   			activity.add_user_invites(user)
	   		end
		end		
	end 
  end
  
# replace activity 
   def  update_activity_participants_by_email (email, activity) 
#in the furue we need to parse a list of users
  	
  	invitees_email_addresses = email.split(',')
  	
  	puts "**********"
  	puts invitees_email_address.inspect
  	puts "**********"
  	
   	if (email != nil && !email.empty?)
    	user = user_by_email(email)
    	if(user !=nil)
   			activity.update_user_invitee (user)
   		end
	end
  	return user
  end
  
  

  

      
    
end
