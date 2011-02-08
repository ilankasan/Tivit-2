module ActivitiesHelper
# returnes a user object. 
#If the user does no exists, it creates a skeloton of an inactive user
# returns nil if email is invalid 

  def user_by_email (email)
  	puts "user_by_email ======================"
  	if(email != nil && !email.empty? )
		puts "if(email != nil && !email.empty? )----------------------------------------"
	  	user  = User.find_by_email(email)
	  	if(user == nil)
	#create an inactive user
			config.debug("--->>> creating a skeloton user for email: "+email)
			params = {:name => "not active",:email => email, :password => "111111",:password_confirmation => "111111"}
			
	#ilan: using temporary password. Deactivated user should not have passwords	
			user = User.create(params)
			user.deactivate_user
	# ilan: missign error handling
	  	end
  	
  end
  return user
  
 end
  
  def  update_activity_participants(email, activity) 
#in the furue we need to parse a list of users
   	puts "update_activity_participants 0909090909090900000000000000000"
  	
   	if (email != nil && !email.empty?)
    	user = user_by_email(email)
    	if(user !=nil)
   			activity.update_user_invites(user)
   		end
	end
  	return user
  end
  
  
  
  

  

      
    
end
