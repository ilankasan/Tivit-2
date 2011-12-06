class PagesController < ApplicationController
  before_filter :authenticate_account!
  
   
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
     
    if((account_session[:filter_id]==nil) && (params[:filter_id]==nil))
      @filter_id = "1"  
    elsif (params[:filter_id] != nil)
      @filter_id = params[:filter_id]
    else
      @filter_id = account_session[:filter_id]
    end
      
    
    case @filter_id
      when ("1") # All
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
              
      when ("2") # my activities
        puts "show my activities"
        @tivits_ondeck             = get_my_activities(current_user_id)
        
      when ("3") # my open tivits
        puts "show open tivits only"
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
        
      when ("4") # my tivits
        puts "show all my tivits includind closed"
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
          
      else
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
        @filter_id = "1"    
      end
# Filter only product On Deck (for now)
    @tivits_completed          = get_activities_completed(current_user_id)
    @need_attention_activities = get_need_attention (current_user_id)
    
    account_session[:filter_id] = @filter_id
  end

  def myteam
    @title = "My Team"
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
