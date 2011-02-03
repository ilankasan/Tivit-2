class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

   def create
    puts "in create"
    @activity  = current_user.activities.build(params[:activity])
    puts "after build"
    
    if (@activity.status == nil)
        @activity.status = "in progress"
    end
    
       puts "in progress"
 
    
    if (@activity.due == nil)
        t = Time.new +1
        @activity.due = t
    end
    
       puts "after due"
 
    
    if @activity.save
      flash[:success] = "tivit created!"
      redirect_to root_path
    else
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