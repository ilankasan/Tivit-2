class PagesController < ApplicationController
  
  def home 
    @activity = Activity.new if signed_in?  
    @title = "Home"
    
    
    
    
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
