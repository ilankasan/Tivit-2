module ActivitiesHelper


  def notify_users_tivit_done(send_to,assigee,comment, tivit)
     send_to.each do |to_user|
     puts "sending done notification to "+to_user.get_email
     
         UserMailer.user_tivit_status_change_done_email(assigee,to_user,comment,tivit).deliver
     end      
      
  end
    
  def validate_user_allowed_to_propose_date (activity, user)
    puts "validating that user can propose a new date "+user.get_name+" for tivit "+activity.get_name
    @error = "Only tivit owner can proposed an alternative date"
    if(user.get_id == activity.get_owner_id )
      return true
    else 
      puts "-----------------------------------------------------"
      puts "Access Denied!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts "-----------------------------------------------------"
      
      return false
    end 
  end


  def validate_user_access_to_activity (activity, user)
    puts "validating that user "+user.get_name+" can access activity "+activity.get_name
    if(user.get_id == activity.get_owner_id || activity.tivits.where(:owner_id => user.get_id).count > 0)
      return true
    else 
      puts "-----------------------------------------------------"
      puts "Access Denied!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts "-----------------------------------------------------"
      
      return false
    end 
  end
  
  def validate_user_allowed_to_close_activity (activity, user)
    puts "validating that user "+user.get_name+" can close activity "+activity.get_name
    return (user.get_id == activity.get_owner_id)
   
  end
  
  
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




 
#Clean comment to be less than 256 chars and no cariege returns
  def clean_comment (comment)
       unless (comment == nil || comment.lstrip.empty?) 
          comment_without_carriage = comment.gsub(/\r/,"")
          comment_without_carriage = comment_without_carriage.gsub(/\n/," ")
      
          if (comment_without_carriage.size > 255)
            comment_without_carriage = comment_without_carriage[0,255]
          end
          return comment_without_carriage
      end
      return comment
   end  
  

###################################################### 
# Add any change of user status to a comment in the activity feed 
######################################################
    def log_action_as_comment(activity,comment,action,user)
      puts "log_action_as_comment"
    	params = {"user_id" =>user.id,"comment" => clean_comment(comment),"action" => action}
    	
    #	puts "log_action_as_comment => "+params.inspect
      
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


  def adjust_date_to_end_of_day(day)
    return day if(day == nil || day.to_s.empty?)
    return day +(1.day - 1.minutes)
  end
#convert year/month/day to one string
   def  parse_date (params, parameter_name) 
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
   	due = Time.utc(params[parameter_name]["year"],params[parameter_name]["month"],params[parameter_name]["day"])		
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
