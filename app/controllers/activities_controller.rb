class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :new,:update, :destroy,:show,:accept,:decline]
  before_filter :authorized_user, :only => :destroy
  
   def create_activity(params, type)
   	puts "------>>>>>>>>>>>>  create_activity"
   	
   	params["due"] = convert_date_to_string(params,"due")
   	params["owner_id"] = current_user.id
   	params["status"]   = "in-progress"
   	params["activity_type"]     = "activity"

   	puts "Inspect Params " +params.inspect
   	@activity = current_user.add_my_ativity(params)    
#Updateting status as Reviewed. New tivits should for current user should be at REviewed status
	@activity.update_status_after_show(current_user)
   	#current.ueractivities.create(params)
 	
   end
   
   def create

# Create Activity
	params["due"] = convert_date_to_string(params,"due")
   		
   @activity = current_user.add_my_ativity(params)    
	
 	
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
    @activity = Activity.find(params[:id])
    @title = "Edit tivit: " +@activity.name
      	
  end

  
  
  def show
    
   puts "----------->>>>>>>>>>> sho activity detailed page"  
    @activity = Activity.find(params[:id])
    #updating tivit status New -> Reviewed and last update to current time
   
    @activity.update_status_after_show(current_user)
    
  	@title = @activity.name
  	
  end
  
  
  
  def update_tivit
#under construction

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
	 		UserMailer.user_tivit_status_completed_email(current_user, invitee_emails,params["summary"],@activity).deliver
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
	 		UserMailer.user_tivit_status_completed_email(current_user, invitee_emails,params["summary"],@activity).deliver
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

   
  def accept
    
   
   puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Accept   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"  
  
   # puts params.inspect  
   
    @activity = Activity.find(params[:id])
    puts "Activity is " + @activity.name  
   
    @activity.update_tivit_user_status_accept(current_user,params["comment"])
    UserMailer.user_tivit_status_change_email(current_user, "Acceped",params["comment"],@activity).deliver
  
	redirect_back_or root_path
  	
  end
  
  def new_tivit
  	@activity = Activity.find(params[:id])
    puts "Addign Tivit to Activity " + @activity.name
    render 'new_tivit'   
   
  end
  
  
  def create_tivit
  	
  	puts "--------------->> create Tvit"
  	puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
   	puts "Inspect Params " +params.inspect
   	puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
   
#adding a strign representation of due date 
  	params["due"] 		= convert_date_to_string(params,"due")
  	params["parent_id"] = params[:id] 						#   adding Parent ID
  	params["invited_by"] = current_user.id 						#   adding invite by		
	params["status"]    = "in-progress"
	 
    invitees = params["invitees"]	
		
	
	user = user_by_email(invitees.strip)
	params["owner_id"] =  user.id
	params["activity_type"] = "tivit"
	
	puts "Inspect Params " +params.inspect
	puts "--------------->>>>  creatintg  activity"

   
	@activity = user.activities.create(params)	 						
	#@activity.create_status(current_user, "Reviewed")
	@activity.update_tivit_user_status_reviewed(current_user,"")
#Adding invitees to activity
	if(@activity!=nil)
      config.debug("------>>>>> creating activity" + @activity.name )
        flash[:success] = "tivit " +@activity.name + " created!"
        UserMailer.new_tivit_email(user,@activity.get_parent.get_owner,@activity).deliver

        redirect_to root_path
    else
        config.debug("creating activity failed")
#ilan: not sure why we need the below row 
        @feed_items = []
        render 'pages/home'
    end
  end

  def done
    
    @activity = Activity.find(params[:id])
    @activity.update_tivit_user_status_i_am_done(current_user,params["comment"])
    if(@activity.isActivity?)
		UserMailer.user_activity_status_change_done_email(current_user,params["comment"],@activity).deliver
    else  
    	UserMailer.user_tivit_status_change_done_email(current_user,params["comment"],@activity).deliver
    end
  	redirect_back_or root_path
  
  end

  
  def propose_date
    puts "-----------    propose date ---------------"
    puts params.inspect  
  	unless params["propose_date"] != nil
    	@activity = Activity.find(params[:id])
    	@activity.update_tivit_user_propose_date(current_user,params["comment"], convert_date_to_string(params,"propose_date"))
    end  
    #UserMailer.user_tivit_status_change_done_email(current_user,params["comment"],@activity).deliver
  	redirect_back_or root_path
  
  end

  
 def decline
    puts "-----------    decline ---------------"  
  
    @activity = Activity.find(params[:id])
    @activity.update_tivit_user_status_decline(current_user,params["comment"])
    UserMailer.user_tivit_status_change_email(current_user, "Declined",params["comment"],@activity).deliver
    		   
  	redirect_back_or root_path
  end

   
  
  
  private
  
	    def authorized_user
      @activity = Activity.find(params[:id])
      redirect_to root_path unless current_user
    end
end