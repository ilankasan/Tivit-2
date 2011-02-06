class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

   def create
    
    
    config.debug("creating activity")
    @activity = current_user.add_my_ativity (params)
    @activity.inspect
    
         
    if (@activity != nil)
      config.debug("creating activity" + @activity.name )
# looking to if user exists
puts "-----   inspectign Hash ---------------------------------- " + params.inspect
    
	  email = nil
	  if(email == nil)
 			puts "email is null---------------------------------------"
 	 end

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