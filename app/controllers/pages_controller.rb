class PagesController < ApplicationController
  
  def home
    @title = "Home"
    if signed_in?
      @activity = Activity.new
      
      puts "before current user" 

      #@feed_items_new                     = current_user.feed.paginate(:page => params[:page])
      #@feed_items1 = current_user.feed.paginate(:page => params[:page])
      puts "******************************"
	  puts "current user is "+current_user.inspect
      @tivits_owned       = current_user.activities.find_all_by_owner_id(current_user.get_id)
      @tivits_participate = current_user.activities.where("not owner_id = ?", current_user.get_id)
      #sql = "SELECT * FROM activities WHERE NOT owner_id = "+current_user.get_id.inspect  
  
      #@tivits_participate = Activity.find_by_sql(sql)
      
      
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
