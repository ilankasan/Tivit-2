class PagesController < ApplicationController
  
  def home
    @title = "Home"
    if signed_in?
      @activity = Activity.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
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
