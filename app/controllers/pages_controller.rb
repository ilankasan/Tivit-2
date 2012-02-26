class PagesController < ApplicationController
  #before_filter :authenticate_account!
  before_filter :authenticate_account!, :except=>[:home1]
#  skip_before_filter :authenticate_account!, :only => [:home1]                                                 
  # [Yaniv] This line disables the CSRF protection by rails when "post" is done outside of the controller (in our case my jQuery stuff). It's not recommended
  # but to make this work I need to do something in the code which I need to continue to research
  # See details here: http://stackoverflow.com/questions/3558816/what-does-this-mean-actioncontrollerinvalidauthenticitytoken
  # this solution didn't work for me: http://stackoverflow.com/questions/1245618/rails-invalidauthenticitytoken-for-json-xml-requests
  skip_before_filter :verify_authenticity_token
   
  def activities
    @title = "Activities"
  end
  
  def awaiting_confirmation(resource)
   puts "resource " + resource.inspect
   #render "http://www.google.com"
   render 'awaiting_confirmation'
   return
   
 end
 

def home
    puts "HHHHHHHHHHHHHHHHHHHHOOOOOOOOOOOOOOOOOOOOOOOOOMMMMMMMMMMMMMMMMMEEEEEEEEEEEEEEEEEEEE"
    @title = "Home"
    
    puts "Home"
       
    current_user_id = current_account.user.get_id.to_s
    puts "current_user_id = "+current_user_id
    puts "Sign in account = "+current_account.sign_in_count.to_s
    if(current_account.sign_in_count == 1 && !account_session[:show_help] == true )
      puts "befor render"
      render 'help'
      account_session[:show_help] = true
      return
    else

     
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
         # puts "My tivits"
         @activities_summary             = get_activities_i_have_open_tivits (current_user_id)
         
      when ("3") # All unresponded
         # puts "All unresponded"
           @activities_summary            = get_activities_i_participate (current_user_id)
           
      when ("4") # All open
         # puts "All open"
          @activities_summary             = get_activities_i_participate (current_user_id)
          
        else
          @activities_summary             = get_activities_i_participate (current_user_id)
          @filter_id = "1"    
        end
  # Filter only product On Deck (for now)
  puts "__________________________________________________________"
      @completed_activities          = get_activities_completed_or_with_completed_tivits(current_user_id)
      @incoming_activities           = get_activities_with_new_tivit_requests(current_user_id)
      
      account_session[:filter_id] = @filter_id
     end
  end


  def myteam
    @title = "My Team"
  end
 
  def bireport
     @title = "Analytics"
     @user_adopt   = get_user_stats
     @tivit_stats  = get_tivits_stats
     #@users = User.paginate(:page => params[:page], :per_page => 30)
     #@users = User.joins(:account).order(:current_sign_in_at).reverse_order.paginate(:page => params[:page], :per_page => 25)
     @users = User.joins("LEFT OUTER JOIN accounts ON accounts.id = users.account_id").order(:current_sign_in_at,:created_at).reverse_order.paginate(:page => params[:page], :per_page => 25)
     
     @active_users = User.where(:is_active => true)
     puts "Number of active user is = "+@active_users.size.to_s
     
  end

  def help
     @title = "How it works?"
  end
  
  def myaccount
     @title = "My Account"
  end
   
  def about
     @title = "About"
  end

end

