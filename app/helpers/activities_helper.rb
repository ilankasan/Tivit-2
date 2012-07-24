module ActivitiesHelper


# [07/08/2012] Yaniv: Return the task status line sting for the specific user 
def get_task_status_line (task, user)
    
  owner_tivit_status = task.get_owner_status

  #*** 1 *** figure out the status line user name  
  if (task.get_owner.id == current_account.user.get_id)
    loggedInUserIsTheOwner = "yes"
    task_owner_name = "You"
  else
    loggedInUserIsTheOwner = "no"
    #task_owner_name = task.get_owner.name
    task_owner_name = render :partial => 'users/user_link', :collection =>  [task.get_owner], :as => :user 
    
   
  end

  #task_invited_by = render :partial => 'users/user_link', :collection =>  [task.get_invited_by], :as => :user 
  task_invited_by = task.get_invited_by.get_name
  #task_invited_by = "INVITED BY"
  
  if task.get_owner.name == "not active"
    task_owner_name = task.get_owner.clone_email
  end

  #*** 2 *** Figure out the appropriate window to determine the statusline relevant text
  due_time_window = task.get_due_window_from_now
  if (task.due == nil) 
    status_line_window = ""

  elsif (due_time_window == "overdue")
    #activity is overdue -->
    if ( (((Time.now.end_of_day - task.due.localtime.end_of_day)/(3600*24)).to_i) == 1 )
      status_line_window = " yesterday"
    else 
      status_line_window = " " + (((Time.now.end_of_day - task.due.localtime.end_of_day)/(3600*24)).to_i).to_s + " days ago"
    end
  
  elsif (due_time_window == "today")
    #activity due today -->
    status_line_window = " today."
      
  elsif due_time_window == "tomorrow"
    #activity due tomorrow
    status_line_window = " tomorrow."
        
  elsif (due_time_window == "withinaweek")
    #activity due within a week
    status_line_window = " " + (task.due.strftime ("%a")) + ", " + (task.due.strftime ("%b")) + " " + (task.due.strftime ("%d")) + "."
  else
    #activity due within more than a week
    status_line_window = " " + (task.due.strftime ("%a")) + ", " + (task.due.strftime ("%b")) + " " + (task.due.strftime ("%d")) + "."
  end

  #*** 3 *** the middle text in status line varies dpending on the status of each tivit, let's set it up based on the status -->
  status_line_middle = ""
  
  if (task.isCompleted?)
    status_line_middle = " finished this " +  (time_ago_in_words (task.completed_at)) + " ago."
    status_line_window = ""
    
  elsif ( TivitStatus.is_proposed_id?(owner_tivit_status) )
    proposed_date = "no data was set"
    if (task.get_owner_proposed_date == nil || task.get_owner_proposed_date == "")
      proposed_date = "[no data was set]"
    else
      proposed_date = (task.get_owner_proposed_date.localtime.strftime("%A %b %d, %Y"))
    end
  
    status_line_middle = " requested a different date: " + proposed_date
    
  elsif (task.due != nil && task.due.localtime.end_of_day < Time.now.end_of_day)
      
    if (owner_tivit_status == TivitStatus.get_new_id || owner_tivit_status == TivitStatus.get_reminded_id)
      if (task_owner_name == "You")
        status_line_middle = " haven't read this."
      else
        status_line_middle = " hasn't read this."
      end
  
    elsif (owner_tivit_status == TivitStatus.get_onit_id || owner_tivit_status == TivitStatus.get_accepted_id)
      
      status_line_middle = " agreed to help "
       if (task.get_owner.get_id != task.get_invited_by.get_id)
         status_line_middle += task_invited_by
       end
       
      status_line_middle += " by "
             
    elsif (owner_tivit_status == TivitStatus.get_reviewed_id)
      if (task_owner_name == "You")
        status_line_middle = " haven't responded."
      else
        status_line_middle = " hasn't responded."
      end
      
   else
      status_line_middle = " ***un-handled status case*** "
   end
            
  elsif (owner_tivit_status == TivitStatus.get_onit_id || owner_tivit_status == TivitStatus.get_accepted_id)

    if (task.due != nil)
       status_line_middle = " agreed to help "
       if (task.get_owner.get_id != task.get_invited_by.get_id)
         status_line_middle += task_invited_by
       end
      status_line_middle += " by "
    else
      status_line_middle = " agreed to help"
      if (task.get_owner.get_id != task.get_invited_by.get_id)
        status_line_middle += " " + task_invited_by 
      end
    end
  
  elsif (owner_tivit_status == TivitStatus.get_new_id || owner_tivit_status == TivitStatus.get_reminded_id)

    if (task_owner_name == "You")
      status_line_middle = " haven't read this."
    else
      status_line_middle = " hasn't read this."
    end
  
    if (task.due != nil)
      status_line_window = " Due " + status_line_window
    else
        status_line_window = ""
    end
  
  elsif (owner_tivit_status == TivitStatus.get_reviewed_id)
  
    if (task_owner_name == "You")
      status_line_middle = " haven't responded."
    else
      status_line_middle = " hasn't responded."
    end
  
    if (task.due != nil)
      status_line_window = " Due " + status_line_window
    else
      status_line_window = ""
    end

  elsif (owner_tivit_status == TivitStatus.get_reassigned_id)
        
    if (task.get_invited_by.id == current_account.user.id)
      task_owner_name = "You"
    else
      task_owner_name = task.get_invited_by.get_name
    end
      
    if (task.get_owner.id == current_account.user.id)
        status_line_middle = " reassigned to you."
    else
      status_line_middle = " reassigned to " +  task.get_owner.get_name
    end
      
    if (task.due != nil)
      status_line_window = " Due " + status_line_window
    else
      status_line_window = ""
    end
                                  
  else                              

    status_line_middle = " can't help."
    status_line_window = ""
  
  end
 
  status_line = task_owner_name + status_line_middle + status_line_window
  return status_line
                             
end          
  
  
  
  
  def owner_need_to_respond? (activity, user)
    
    if ((activity.get_owner.id == current_account.user.id) && 
        (    activity.get_owner_status == TivitStatus.get_new_id || activity.get_owner_status == TivitStatus.get_reminded_id || activity.get_owner_status == TivitStatus.get_reviewed_id))
      return true
    else
      return false    
    end
  end
  
  def notify_users_tivit_done(send_to,assigee,comment, tivit)
    
    send_to.each do |to_user|
      puts "sending done notification to "+to_user.get_email
#UserMailer.tivit_status_done_email(assigee,to_user,comment,tivit).deliver
      EMAIL_QUEUE << {:email_type => "tivit_done_email", :assigner => to_user , :assignee => assigee,:comment =>comment, :tivit =>tivit}
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
    puts "validating that user "+user.get_name+" with id "+ user.get_id.to_s+"can access activity "+activity.get_name
    #if(user.get_if== activity.get_owner_id || activity.tivits.where(:owner_id => user.get_id).count > 0)
    return true if(user == activity.get_owner)
    parent = activity.get_parent  
    return true if(parent != nil && user == parent.get_owner) 
     
    return true if (activity.tivits.where(:owner_id => user.get_id).count > 0)
    
    if( parent != nil && parent.tivits.where(:owner_id => user.get_id).count > 0)
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
    puts "in ---->>>   user_by_email "+email_input
  	if(email_input != nil && !email_input.empty? )
		@email = email_input.downcase
  	
		puts "------------------ adding new invitee: " + @email 
	  	account  = Account.find_by_email(@email)
	  	#if(false && @email == "ilan.kasan1@gmail.com")
	  	#   puts "destrot account!!!!!!"
	  	#   account.destroy
	  	#   account = nil
	  	#end
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
      return "" if comment == nil
      unless (comment == nil || comment.lstrip.empty?) 
          comment_without_carriage = comment.gsub(/\r/,"")
          comment_without_carriage = comment_without_carriage.gsub(/\n/," ")
      
          if (comment_without_carriage.size > 1024)
            comment_without_carriage = comment_without_carriage[0,1023]
          end
          return comment_without_carriage
      end
      return comment
   end  
  

###################################################### 
# Add any change of user status to a comment in the activity feed 
######################################################
    def log_action_as_comment(activity,comment,action,user)
      puts "log_action_as_comment. Action = "+action
    	params = {"user_id" =>user.id,"comment" => clean_comment(comment),"action" => action}
    	
    #	puts "log_action_as_comment => "+params.inspect
      
    	return activity.tivitcomments.create(params)
	  end
###################################################### 
# add participants to activity 
######################################################

  def  add_activity_participants(emails, activity) 
#in the furue we need to parse a list of users
  	
  	invitees = emails.split(/;|,/)
  	
  	
  	#puts "#######################################################"
  	#puts invitees.inspect
  	#puts "######################################################"
  	
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
   	#		puts date.inspect
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
   def get_activity_users(activity)
     puts "get activity users"
     
     sql = "SELECT DISTINCT users.* FROM users, activities, activities_users 
                 WHERE activities.parent_id    = " +activity.id.to_s + "
                 AND activities.id             = activities_users.activity_id  
                 AND users.id                  = activities_users.user_id"
   
   
    @users = User.find_by_sql(sql)
    return @users
   end
   
   def notify_users_activity_is_closed(activity,summery,activity_owner)
     puts "in notify users"
     users = get_activity_users(activity)
     users.each do |user|
       
#202 Activity - Closed. When Owner closes activity, Who: All Assignees
      if(user != activity_owner)
        EMAIL_QUEUE << {:email_type => "activity_completed_email", :stakeholder => user , :activity_owner => activity.get_owner,:comment => summery, :activity =>@activity}
      end
     
     end
   
   end
      
     
end
