class PagesController < ApplicationController
  
  def home
    @title = "Home"
    if signed_in?
      @activity = Activity.new #ilan:not sure this is needed
      puts "before current user" 

      #@feed_items_new                     = current_user.feed.paginate(:page => params[:page])
      #@feed_items1 = current_user.feed.paginate(:page => params[:page])
      #@tivits_owned       = current_user.activities.find_all_by_owner_id(current_user.get_id)
      @tivits_owned       = current_user.activities.where("NOT status = ? AND owner_id = ?"    ,"Completed", current_user.get_id)
      @tivits_participate = current_user.activities.where("NOT status = ? AND NOT owner_id = ?","Completed", current_user.get_id)
      
#this SQL retrieves all new tivits for me eccpet the ones i am the owner
	  current_user_id = current_user.get_id.inspect
   #   sql_new_tivits = "SELECT activities.* FROM activities, tivit_user_statuses WHERE NOT activities.owner_id = "+current_user_id+" AND tivit_user_statuses.activity_id = activities.id AND tivit_user_statuses.status_id = 'New' AND tivit_user_statuses.user_id = "+current_user_id
      sql_new_tivits = "SELECT activities.* FROM activities, tivit_user_statuses 
      				   WHERE NOT activities.status         = 'Completed' 
      				   AND   NOT activities.owner_id       = "+current_user_id+" 
      				   AND tivit_user_statuses.activity_id = activities.id 
      				   AND tivit_user_statuses.status_id   = 'New' 
      				   AND tivit_user_statuses.user_id     = "+current_user_id
	 
	  @tivits_new          = Activity.find_by_sql(sql_new_tivits)
      
      
      #@new_tivits = current_user.activities.find_by_owner_id(current_user.get_id)
      
      
      if(@tivits_owned!= nil)
      	puts "user has owners!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    "

      		puts @tivits_owned.inspect
      else
      	puts "user has no tasks"

      end
      
      	
	  #@feed_items_tivits_i_participate    = current_user.feed.paginate(:page => params[:page])
	 
     end
  end
  
  def activities
    @title = "Activities"
  end

  def myteam
    @title = "My Team"
  end

  def signout
     @title = "tiviti - Sign in"
  end

  def myaccount
     @title = "My Account"
  end
   
  def about
     @title = "About"
  end

end
