class PagesController < ApplicationController
  before_filter :authenticate_account!
  
  def home
    @title = "Home"
    #if  account_signed_in? && current_account.user != nil      
# returns all activities that are not completed abd i either own or i have a a tivit (tivit can be completed or not)
  	current_user_id = current_account.user.get_id.inspect

   	@tivits_completed          = get_activities_completed(current_user_id)
    @tivits_ondeck             = get_activities_i_participate (current_user_id)
    @need_attention_activities = get_need_attention (current_user_id)
  end
  
  def activities
    @title = "Activities"
  end
  
  def filter
    puts "Filterintg"
    puts "Params = "+params.inspect
    current_user_id = current_account.user.get_id.inspect
    @title = "Home"
    
    
    case params[:filter_id]
      when ("1") # All
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
              
      when ("2")
        @tivits_ondeck             = get_my_activities(current_user_id)
        
      end

    @tivits_completed          = get_activities_completed(current_user_id)
    @need_attention_activities = get_need_attention (current_user_id)

    render 'home'
    
  end

  def myteam
    @title = "My Team"
  end

  def signout
     @title = "Sign in"
  end

  def bireport
     @title = "Product Adoption Dashboard"
     @user_adopt   = get_user_stats
     @tivit_stats  = get_tivits_stats
  end


  def myaccount
     @title = "My Account"
  end
   
  def about
     @title = "About"
  end

end
