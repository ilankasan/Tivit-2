module ActivitiesHelper
# returnes a user object. 
#If the user does no exists, it creates a skeloton of an inactive user
  def user_by_email (email)
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
  	return user
  end
  
  
      
    
end
