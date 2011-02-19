class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

   def create
    
    config.debug("------>>>>> Creating activity")
    #adding a strign representation of due date 
    params["due"] = convert_date_to_string(params,"due") 
#adding activity to current user	
    @activity = current_user.add_my_ativity (params)    
	    
    if (@activity != nil)
		invitees = params["invitees"]	
		
	
#Adding invitees to activity
		if (invitees != nil && invitees.empty? == false)
    		add_activity_participants(invitees, @activity)
    	end     

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
  
  def destroy
    @activity.destroy
    redirect_back_or root_path
  end
  
  
  def edit
  
    @activity = Activity.find(params[:id])
    @title = "Edit tivit: " +@activity.name
    
  end
  
  
  def show
    
    @activity = Activity.find(params[:id])
  	@title = @activity .name
  	
  end
  
  def update
    
    @activity = Activity.find(params[:id])   
    
    puts params.inspect
    puts "----------->>>>>>>>>>>"  
    params["due"] = convert_date_to_string(params, "due")
    puts "-----------<<<<<<<<<<<<<<<<<<"
    puts "-----------<<<<<<<<<<<<<<<<<<" 
    puts params 
 	puts "-----------<<<<<<<<<<<<<<<<<<" 
    
    
# update task status
	if(params["status"] == "true")
		params["status"] = "completed"
		params["completed_at"] = Time.new

	else
		params["status"] = "in-progress"
	end
	
	puts "-------->>>>>>>>>>>>>  STATUS = "+params["status"] 
    
	
    if (@activity != nil && @activity.update_attributes(params))
      
      invitee_emails = params["invitees"]	
      
      update_activity_participants_by_email(invitee_emails, @activity)    
      
      #add_activity_participants (invitee_email,@activity)
      @activity.save
    
      flash[:success] = "tivit " + @activity.name + " updated"
      redirect_to @activity
      
    else
      @title = "Edit activity"
      render 'edit'
    end  
  end 


  private

    def authorized_user
      @activity = Activity.find(params[:id])
      redirect_to root_path unless current_user
    end
end