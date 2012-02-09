class PagesController < ApplicationController
  #before_filter :authenticate_account!
  before_filter :authenticate_account!, :except=>[:home1]
  skip_before_filter :authenticate_account!, :only => [:home1]                                                 
  # [Yaniv] This line disables the CSRF protection by rails when "post" is done outside of the controller (in our case my jQuery stuff). It's not recommended
  # but to make this work I need to do something in the code which I need to continue to research
  # See details here: http://stackoverflow.com/questions/3558816/what-does-this-mean-actioncontrollerinvalidauthenticitytoken
  # this solution didn't work for me: http://stackoverflow.com/questions/1245618/rails-invalidauthenticitytoken-for-json-xml-requests
  skip_before_filter :verify_authenticity_token
   
  def activities
    @title = "Activities"
  end
  
  def awaiting_confirmation(resource)
#   puts "---------->>>>>>>>>>>>> confirm message  <<<<__________________"
   puts "resource " + resource.inspect
   #render "http://www.google.com"
   render 'awaiting_confirmation'
   return
   
 end
 
#<%= select_tag(:filter_id, options_for_select([['On Deck', 1],['Just My Tivits', 2], ['All Unresponded', 3],['All Open', 4]],account_session[:filter_id])) %>

def home
    @title = "Home"
    
    puts "Home"
    #puts "Params = "+params.inspect
    #if(account_session[:flash_error] != nil && !account_session[:flash_error].empty?)
      
      #flash[:failed] = account_session[:flash_error]
     # puts "flash = "+ flash.inspect 
     # account_session[:flash_error] = nil
    #end
    current_user_id = current_account.user.get_id.inspect
    puts "current_user_id = "+current_user_id
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
    when ("1") # On Deck
        @activities_summary             = get_activities_i_participate(current_user_id)
              
    when ("2") # Just My tivits
        puts "Just My tivits"
       @activities_summary             = get_activities_i_have_open_tivits (current_user_id)
       
        
    when ("3") # All unresponded
        puts "All unresponded"
         @activities_summary             = get_activities_i_participate (current_user_id)
      
        
    when ("4") # All open
        puts "All open"
        @activities_summary             = get_activities_i_participate (current_user_id)
    
          
      else
        @activities_summary             = get_activities_i_participate (current_user_id)
        #not sure we get here.
        @filter_id = "1"    
      end
# Filter only product On Deck (for now)
    @completed_activities          = get_activities_completed_or_with_completed_tivits(current_user_id)
  #  puts "----------------    111111111111111111111111   completed activities "
  #  puts @completed_activities.inspect
        
    
    @incoming_activities       = get_activities_with_new_tivit_requests(current_user_id)
  #  @need_attention_activities = get_need_attention (current_user_id)
    
    account_session[:filter_id] = @filter_id
  end


                
  def old_home_old
    @title = "Home"
    
    puts "Home"
    #puts "Params = "+params.inspect
    #if(account_session[:flash_error] != nil && !account_session[:flash_error].empty?)
      
      #flash[:failed] = account_session[:flash_error]
     # puts "flash = "+ flash.inspect 
     # account_session[:flash_error] = nil
    #end
    current_user_id = current_account.user.get_id.inspect
    puts "current_user_id = "+current_user_id
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
    when ("1") # On Deck
        @tivits_ondeck             = get_activities_i_participate(current_user_id)
              
      when ("2") # my activities
        puts "show my activities"
        @tivits_ondeck             = get_my_activities(current_user_id)
        
      when ("3") # my open tivits
        puts "show open tivits only"
        #@tivits_ondeck             = get_activities_i_participate (current_user_id)
        @tivits_ondeck             = get_activities_i_have_open_tivits (current_user_id)
        
      when ("4") # my tivits
        puts "show all my tivits"
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
    
      when ("5") # All
        puts "show all my tivits"
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
          
      else
        @tivits_ondeck             = get_activities_i_participate (current_user_id)
        @filter_id = "1"    
      end
# Filter only product On Deck (for now)
    @tivits_completed          = get_activities_completed(current_user_id)
    @incoming_activities       = get_activities_with_new_tivit_requests(current_user_id)
  #  @need_attention_activities = get_need_attention (current_user_id)
    
    account_session[:filter_id] = @filter_id
  end

  def myteam
    @title = "My Team"
  end

  

  def bireport
     @title = "Product Adoption Dashboard"
     @user_adopt   = get_user_stats
     @tivit_stats  = get_tivits_stats
     #@users = User.paginate(:page => params[:page], :per_page => 30)
     @users = User.joins(:account).order(:current_sign_in_at).reverse_order.paginate(:page => params[:page], :per_page => 25)
     
     #emails = Account.joins(:user).where(:id => current_account.user.mycontacts)
  #   @accounts = Account.paginate(:page => params[:page], :per_page => 25).order(:current_sign_in_at)
  end


  def myaccount
     @title = "My Account"
  end
   
  def about
     @title = "About"
  end

end
