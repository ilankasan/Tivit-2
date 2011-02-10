class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

   def create
    
    config.debug("------>>>>> Creating activity")
    due = Time.local(params["due"]["year"],params["due"]["month"],params["due"]["day"])
#adding a strign representation of due date 
    params["due"] = due.inspect 
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
    
    if (@activity != nil && @activity.update_attributes(params[:activity]))
      
      invitee_email = params["invitees"]	
      
      update_activity_participants_by_email(invitee_email, @activity)    
      
      #add_activity_participants (invitee_email,@activity)
      
      flash[:success] = "tivit" + @activity.name + " updated"
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