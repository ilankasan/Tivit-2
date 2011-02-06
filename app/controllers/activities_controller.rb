class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

   def create
    
    
    config.debug("------>>>>> Creating activity")
    due = Time.local(params["due"]["year"],params["due"]["month"],params["due"]["day"])
	config.debug("------>>>>> due date "+due.inspect)
    
	params["due"] = due.inspect 

    @activity = current_user.add_my_ativity (params)
    
         
    if (@activity != nil)
      config.debug("------>>>>> creating activity" + @activity.name )
# looking to if user exists
    
	  email = nil

      user = User.find_by_email(email)
      if(user == nil && email != nil)
      	flash[:warning] = "Use with email " + email + "does not have an account" 
      end
      flash[:success] = "tivit " +@activity.name + " created!"
      redirect_to root_path
    else
      config.debug("creating activity failed") 
      @feed_items = []
      render 'pages/home'
    end
  
  end
  
  
  def destroy
    @activity.destroy
    redirect_back_or root_path
  end

  private

    def authorized_user
      @activity = Activity.find(params[:id])
      redirect_to root_path unless current_user?(@activity.user)
    end
end