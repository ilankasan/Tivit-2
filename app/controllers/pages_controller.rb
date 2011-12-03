class PagesController < ApplicationController
  before_filter :authenticate_account!
  
  def home_old
    @title = "Home"
      puts "--   HOME ----------"
  
    account_session[:filter_id] = "1" if account_session[:filter_id] == nil 
     
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
  
  def home
    @title = "Home"
    
    puts "Home"
    puts "Params = "+params.inspect
    puts "session = "+account_session.inspect
     
    current_user_id = current_account.user.get_id.inspect
    @title = "Home"
    
    #ccount_session[:filter_id] = "1" if account_session[:filter_id] == nil
     
    if((account_session[:filter_id] == nil) && (params[:filter_id]==nil))
      filter_id = "1"  
    elsif (params[:filter_id] != nil)
      filter_id = params[:filter_id]
    else
      filter_id = account_session[:filter_id]
    end
      
    
    case filter_id
      when ("1") # All
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
        @mytivits = false
              
      when ("2") # my activities
        puts "show my activities"
        @tivits_ondeck             = get_my_activities(current_user_id)
        @mytivits = false
    
      when ("3") # my tivits
        puts "show tivits only"
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
        @mytivits = true
      else
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
        @mytivits = false    
      end
# Filter only product On Deck (for now)
    @tivits_completed          = get_activities_completed(current_user_id)
    @need_attention_activities = get_need_attention (current_user_id)
    
    account_session[:filter_id] = filter_id
 #   render 'home'
    
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
