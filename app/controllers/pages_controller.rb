class PagesController < ApplicationController
  
  def home
    @title = "Home"
    if signed_in?
      @activity = Activity.new
      
      puts "before current user" 

      @feed_items = current_user.feed.paginate(:page => params[:page])
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
