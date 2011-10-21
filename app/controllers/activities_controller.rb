class ActivitiesController < ApplicationController
  before_filter :authenticate_account!
  
  
  
   def create_activity(params, type)
   	puts "------>>>>>>>>>>>>  create_activity"
   	
   	params["due"] = convert_date_to_string(params,"due")
   	params["owner_id"] = current_account.user.id
   	params["status"]   = "in-progress"
   	params["activity_type"]     = "activity"

   	puts "Inspect Params " +params.inspect
   	@activity = current_account.user.add_my_ativity(params)    
#Updateting status as Reviewed. New tivits should for current user should be at REviewed status
	@activity.update_status_after_show(current_account.user)
   	#current.ueractivities.create(params)
 	
   end
   
   def create

# Create Activity
	params["due"] = convert_date_to_string(params,"due")
   		
   @activity = current_account.user.add_my_ativity(params)    
	
 	
# Adding activity to current user	
        
    if (@activity != nil)
		invitees = params["invitees"]	
		
	
#Adding invitees to activity
		if (invitees != nil && invitees.empty? == false)
    		add_activity_participants(invitees, @activity)
# email invitee an email
			#UserMailer.new_tivit_email(user,owner,self).deliver

    	end     

        config.debug("------>>>>> creating activity" + @activity.name )
        flash[:success] = "tivit " +@activity.name + " created!"
#        redirect_to root_path
#redirect_to 'shared/activitydetails'
        render 'show'
                       
    else
        config.debug("creating activity failed")
#ilan: not sure why we need the below row 
        @feed_items = []
        render 'pages/home'
    end
  end
  
  def destroy
    
    
#ilan: Need to send an email notifying all participants the activity and tivit
	related_tivits = @activity.tivits
    related_tivits.each do |tivit|
    	tivit.destroy
  	end 
    @activity.destroy
      
    redirect_back_or root_path
  end
  
  
  def edit
  	puts "edit activit"
        @activity = Activity.find(params[:id])
    @title = "Edit tivit: " +@activity.name
  end
  
  def remove_tivit
	puts "Remove Tivit"
	@tivit = Activity.find(params[:id])
	@tivit.destroy
	redirect_back_or root_path
      	
  end
  
  
  def edit_tivit
  	puts "edit tivit"
  	puts params.inspect  
    
    @activity = Activity.find(params[:id])
    @title = "Edit tivit: " +@activity.name
      	
  end

  
  
  def show
    
   puts "----------->>>>>>>>>>> sho activity detailed page"  
    @activity = Activity.find(params[:id])
    #updating tivit status New -> Reviewed and last update to current time
   
    @activity.update_status_after_show(current_account.user)
    
  	@title = "Activity Details - "+@activity.name
  	
  end
  
  
  
  def update_tivit
#under construction

    puts "-----------    UPDATE tivit"  
    puts params.inspect
    puts "-----------    UPDATE tivit"  
    
    @activity = Activity.find(params[:id])   
    
    puts params.inspect
    params["due"] = convert_date_to_string(params, "due")
   
    
# update activity status to completed if check box was checked 
	
	if(params["activity_status"] == "true")
		params["activity_status"] = "Completed"
#		params["completed_at"] = time.localtime
	else
		params["activity_status"] = "in-progress"
	end

	  
# vhecking to see if tthe task was previously closed. This will be used before the email is sent out below
	was_completed = @activity.status
	if (@activity != nil && @activity.update_attributes(params))
      puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" +params["activity_status"]
      
 	  @activity.update_activity_status(params["activity_status"]) 
 
      invitee_emails = params["invitees"]	
      
      update_activity_participants_by_email(invitee_emails, @activity)
      @activity.save
      
#send email to all parcicipants that tivit was completed (not including owner):
	  if(was_completed != "Completed" && @activity.status == "Completed" )
	 		UserMailer.user_tivit_status_completed_email(current_account.user, invitee_emails,params["summary"],@activity).deliver
	  end

	  flash[:success] = "tivit " + @activity.name + " updated"
      redirect_to @activity
      
    else
   	  flash[:failed] = "Errrorrororororor"
      @title = "Edit activity"
      render 'edit'
    end  
  end

  
  
  
  def update
   
    puts "-----------    UPDATE ------llllllllll---------"  
    
    @activity = Activity.find(params[:id])   
    
    puts params.inspect
    params["due"] = convert_date_to_string(params, "due")
   
    
# update activity status to completed if check box was checked 
	
	if(params["activity_status"] == "true")
		params["activity_status"] = "Completed"
#		params["completed_at"] = time.localtime
	else
		params["activity_status"] = "in-progress"
	end

	  
# vhecking to see if tthe task was previously closed. This will be used before the email is sent out below
	was_completed = @activity.status
	if (@activity != nil && @activity.update_attributes(params))
      puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" +params["activity_status"]
      
 	  @activity.update_activity_status(params["activity_status"]) 
 
      invitee_emails = params["invitees"]	
      
      update_activity_participants_by_email(invitee_emails, @activity)
      @activity.save
      
#send email to all parcicipants that tivit was completed (not including owner):
	  if(was_completed != "Completed" && @activity.status == "Completed" )
	 		UserMailer.user_tivit_status_completed_email(current_account.user, invitee_emails,params["summary"],@activity).deliver
	  end

	  flash[:success] = "tivit " + @activity.name + " updated"
      redirect_to @activity
      
    else
   	  flash[:failed] = "Errrorrororororor"
      @title = "Edit activity"
      render 'edit'
    end  
  end
  
  def change_tivit_status
    
    puts "<<<<<<<<<<<<----------->>>>>>>>>>>"  
    puts params.inspect  
 #ilan: the below can be optimized   
    @activity = Activity.find(params[:id])
    
    status = params["status"]
    @action = status
# need to clean section below
    if(status.downcase == "Done")
    	@title= "I Am Done!"
    else 
    	@title  = status.capitalize
    end
    render 'tivit_status_change'      
  end

   
  def on_it
   
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   On It   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"  
    @activity = Activity.find(params[:id])
    puts "Activity is " + @activity.name  
   
    @activity.update_tivit_user_status_onit(current_account.user,params["comment"])
    log_action_as_comment(@activity,params["comment"],"OnIt",current_account.user)

    UserMailer.user_tivit_status_change_email(current_account.user, "On it",params["comment"],@activity).deliver
  
	redirect_to  root_path
  	
  end
  
  def new_tivit
  	@activity = Activity.find(params[:id])
    puts "Addign Tivit to Activity " + @activity.name
    render 'new_tivit'   
   
  end
  
  
  def create_tivit
  	
  	puts "--------------->> create Tvit"
  	
#adding a strign representation of due date 
  	params["due"] 		= convert_date_to_string(params,"due")
  	params["parent_id"] = params[:id] 						#   adding Parent ID
  	params["invited_by"] = current_account.user.id 						#   adding invite by		
	params["status"]    = "in-progress"
	 
    invitees = params["invitees"]	
		
	
	@invited_user = user_by_email(invitees.strip)
	params["owner_id"] =  @invited_user.id
	params["activity_type"] = "tivit"
	
	puts "Inspect Params " +params.inspect
	puts "--------------->>>>  creatintg  tiviti"

   	current_account.user.addContect(@invited_user)
   	@invited_user.addContect(current_account.user)
	@activity = @invited_user.activities.create(params)	 						
	@activity.update_tivit_user_status_reviewed(current_account.user,"")
	config.debug("------>>>>> creating activity" + @activity.name )
    UserMailer.new_tivit_email(@invited_user,current_account.user,@activity).deliver
    redirect_to root_path
  end

  def done
    
    @activity = Activity.find(params[:id])
    @activity.update_tivit_user_status_i_am_done(current_account.user,params["comment"])
    log_action_as_comment(@activity,params["comment"],"Done",current_account.user)

    if(@activity.isActivity?)
		UserMailer.user_activity_status_change_done_email(current_account.user,params["comment"],@activity).deliver
    else  
    	UserMailer.user_tivit_status_change_done_email(current_account.user,params["comment"],@activity).deliver
    end
  	redirect_to  root_path
  	#render 'shared/activitydetails'
  				
  
  end

  
  def propose_date
    puts "-----------    propose date ---------------" + params["propose_date"]
    
    puts params.inspect  
  	unless (params["propose_date"] == nil)
    	@activity = Activity.find(params[:id])
    	puts "old date = "+@activity.due.inspect
    	puts "new date = "+ params["propose_date"]
    	
    	@activity.update_tivit_user_propose_date(current_account.user,params["comment"], convert_date_to_string(params,"propose_date"))
    	log_action_as_comment(@activity,params["comment"],"Proposed",current_account.user)    	
    end  
    #UserMailer.user_tivit_status_change_done_email(current_account.user,params["comment"],@activity).deliver
  	redirect_to  root_path
  	
  end

  
  def accept_date
    puts "-----------    Accept Date ---------------"
    puts params.inspect
   	@activity = Activity.find(params[:id])
    
    log_action_as_comment(@activity,params["comment"],"Accepted",current_account.user)
    puts "Old date = "+ @activity.due.inspect + "   accepted new date  = "+ @activity.get_owner_proposed_date.inspect 
    
    @activity.due = @activity.get_owner_proposed_date
    
  	@activity.update_tivit_user_status_onit(@activity.get_owner,"")
 #ilan: do i need to change the owner status as accepted? maybe later
 
 # we need to send an email to the owner of the tivit the the activity owner accepted the proposed date
    UserMailer.user_tivit_status_change_email(current_account.user, "Accepted proposed date",params["comment"],@activity).deliver

  	redirect_back_or root_path
  
  end

  
 def decline
    puts "-----------    decline ---------------"  
  
    @activity = Activity.find(params[:id])
    @activity.update_tivit_user_status_decline(current_account.user,params["comment"])
    log_action_as_comment(@activity,params["comment"],"Declined",current_account.user)

    UserMailer.user_tivit_status_change_email(current_account.user, "Declined",params["comment"],@activity).deliver
    redirect_to  root_path
  	 
 end

 def remind
    puts "-----------    remind ---------------"  
  
    @activity = Activity.find(params[:id])
# ilan: need to change status to reminded. next version
    @activity.update_tivit_user_status_reminded(@activity.get_owner,params["comment"])
  
    UserMailer.remind_user_to_review_tivit(current_account.user, params["comment"],@activity).deliver
    		   
  	redirect_to  root_path
  	
  end
 
  private
  
	def authorized_user
      @activity = Activity.find(params[:id])
      redirect_to root_path unless current_account.user
    end
end