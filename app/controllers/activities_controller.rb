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
		who = params["who"]
		
#user_by_email (who)
    	update_activity_participants(who, @activity)    
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
    puts "EEEEDDDDIIIYYYYYYYYYYYYYTTTTTTTTTTTTTTTT--------------------"
	
    redirect_back_or root_path
  end


  private

    def authorized_user
      @activity = Activity.find(params[:id])
      redirect_to root_path unless current_user?(@activity.user)
    end
end