class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :new,:update, :destroy,:show,:accept,:decline]
  before_filter :authorized_user, :only => :destroy
  
   def create_activity(params, type)
   	puts "------>>>>>>>>>>>>  create_activity"
   	puts "------>>>>>>>>>>>>  create_activity"
   	puts "------>>>>>>>>>>>>  create_activity"
   	
   	params["due"] = convert_date_to_string(params,"due")
   	params["owner_id"] = current_user.id
   	params["status"]   = "in-progress"
   	params["activity_type"]     = "activity"

   	puts "Inspect Params " +params.inspect
   	@activity = current_user.add_my_ativity(params)    
	
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
    @activity = Activity.find(params[:id])
    @title = "Edit tivit: " +@activity.name
  end
  
  
  def show
    
   puts "----------->>>>>>>>>>> sho show show"  
   # puts params.inspect
   #updating tivit status New -> Reviewed
    @activity = Activity.find(params[:id])
    @activity.update_tivit_status_after_show(current_user)
  	@title = @activity.name
  	
  end
  
  def update
   
    puts "-----------    UPDATE ------llllllllll---------"  
    
    @activity = Activity.find(params[:id])   
    
    puts params.inspect
    params["due"] = convert_date_to_string(params, "due")
   
    
# update task status
	
	if(params["status"] == "true")
		params["status"] = "Completed"
		time = Time.new
		params["completed_at"] = time.localtime
	else
		params["status"] = "in-progress"
	end
# vhecking to see if tthe task was previously closed. This will be used before the email is sent out below
	was_completed = @activity.status
	if (@activity != nil && @activity.update_attributes(params))
      
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
    
    if(status.downcase == "i_am_done")
    	@title= "I Am Done!"
    else 
    	@title  = status.capitalize
    end
    render 'tivit_status_change'      
  end

   
  def accept
    
   puts "----------->>>>>>>>>>>"  
   puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Accept   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
   puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Accept   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"  
   puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Accept   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"  
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
  	puts "create Tvit"
  	puts "create Tvit"
  	puts "--------------->> create Tvit"
  	puts "--------------->> create Tvit"
  	puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
   puts "Inspect Params " +params.inspect
   puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
   
   
   
   puts "--------------->> create Tvit"
  	puts "create Tvit"
  	puts "create Tvit"
  	puts "--------------->> create Tvit"
  	puts "--------------->> create Tvit"

	
#adding a strign representation of due date 
  	params["due"] 		= convert_date_to_string(params,"due")
  	params["parent_id"] = params[:id] 						#   adding Parent ID
  	params["invited_by"] = current_user.id 						#   adding invite by	
		
	params["status"]    = "in-progress"
	
        
    invitees = params["invitees"]	
		
	
	user = user_by_email(invitees.strip)
	params["owner_id"] =  user.id
	params["activity_type"] = "tivit"
	
	puts "Inspect!!!!!!!!!!!!!!!!!"
	puts "Inspect Params " +params.inspect
	puts "--------------->>>>  creatintg  activity"
   
   
	@activity = user.activities.create(params)	 						


#Adding invitees to activity
	if(@activity!=nil)
      config.debug("------>>>>> creating activity" + @activity.name )
        flash[:success] = "tivit " +@activity.name + " created!"
        redirect_to root_path
    else
        config.debug("creating activity failed")
#ilan: not sure why we need the below row 
        @feed_items = []
        render 'pages/home'
    end

   
  end
  

  def i_am_done
    
    @activity = Activity.find(params[:id])
    @activity.update_tivit_user_status_i_am_done(current_user,params["comment"])
    UserMailer.user_tivit_status_change_done_email(current_user,params["comment"],@activity).deliver
  	redirect_back_or root_path
  
  end

  
 def decline
  	puts "----------->>>>>>>>>>>"  
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