class PagesController < ApplicationController
  
  def home
    @title = "Home"
    if signed_in?
      @activity = Activity.new
      
      puts "before current user" 

      @feed_items = current_user.feed.paginate(:page => params[:page])
      @feed_items_other = current_user.activities
    end
  end
  
  def activities
    @title = "tivity Activities"
  end

  def myteam
    @title = "My Team"
  end

  def signout
     @title = "sign out tivity"
  end

  def myaccount
     @title = "tivity My Account"
  end
  
  
  def about
     @title = "About tivity"
  end

end
