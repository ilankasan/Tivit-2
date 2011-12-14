module ActivitiesHelper


# returnes a user object. 
#If the user does no exists, it creates a skeloton of an inactive user
# returns nil if email is invalid 

 
  def user_by_email (email_input)
  	if(email_input != nil && !email_input.empty? )
		@email = email_input.downcase
  	
		puts "------------------ adding new invitee: " + @email 
	  	account  = Account.find_by_email(@email)
	  	
	  	return account.user if !account.nil?
	  	
	  	if(account  == nil)

			 puts "------------------ creating new user: " + @email 
			 @user = User.find_by_clone_email(@email)
			 if(@user == nil)
		 
		    params = {:name => "not active",:clone_email => @email, :is_active  => false}
    
			  @user = User.create(params)
			  end
			return @user
	  	end
	  end
end




 


###################################################### 
# Add any change of user status to a comment in the activity feed 
######################################################


    def log_action_as_comment(activity,comment,action,user)
    	params = Hash.new
    	params["user_id"] = user.id
    	params["comment"] = comment
    	params["action"]  = action
    	activity.tivitcomments.create(params)
	  end
###################################################### 
# add participants to activity 
######################################################

  def  add_activity_participants(emails, activity) 
#in the furue we need to parse a list of users
  	
  	invitees = emails.split(/;|,/)
  	
  	
  	puts "#######################################################"
  	puts invitees.inspect
  	puts "######################################################"
  	
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


def  add_tivit_to_user(emails, activity) 
#in the furue we need to parse a list of users
  	
  	invitees = emails.split(/;|,/)
  	
  	
  	puts "#######################################################"
  	puts invitees.inspect
  	puts "######################################################"
  	
  	invitees.each do |email_address|
  	
 
	   	if (email_address != nil && !email_address.empty?)
	    	user = user_by_email(email_address.strip)
	    	if(user !=nil)
	   			user.activities << activity
	   			activity.owner_id = user.id
	   			
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
   			date = params[parameter_name].split('-')
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
   
# get a colleciton of users that participated in an activity (stakeholders and tivit owners)
   def get_acrivity_users(activity)
     puts "get activity users"
     
     sql = "SELECT DISTINCT users.* FROM users, activities, activities_users 
                 WHERE activities.parent_id    = " +activity.id.to_s + "
                 AND activities.id             = activities_users.activity_id  
                 AND users.id                  = activities_users.user_id"
   
   
    @users          = User.find_by_sql(sql)
    return @users
   end
   
   def notify_users_activity_is_closed(activity,summery)
     puts "in notify users"
     users = get_acrivity_users(activity)
     users.each do |user|
      UserMailer.activity_completed_email(user,summery,activity).deliver
     
     end
   
   end
      
     
end
