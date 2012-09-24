class PagesController < ApplicationController
  #before_filter :authenticate_account!
  before_filter :authenticate_account!, :except=>[:help]
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
   #puts "resource " + resource.inspect
   #render "http://www.google.com"
   render 'awaiting_confirmation'
   return
   
 end

def load_tabs

  @tabToLoad = params[:id]
 # puts "[Yaniv] tab to load=" + @tabToLoad
  
  if ( @tabToLoad == 'activities-tab' )
    @objectsToRender = get_activities_i_participate(current_account.user.get_id.to_s)
  elsif ( @tabToLoad == 'completed-tab' )
     
    @objectsToRender = get_completed_tivits(current_account.user)
    current_account.user.update_reviewed_completed_tasks
    
  elsif ( @tabToLoad == 'tasks-i-asked' ) 
    @objectsToRender = get_tasks_for_other(current_account.user.get_id.to_s)
  else
    return
  end
     
   puts "[Yaniv] @objectsToRender = " + @objectsToRender.size.to_s
   
   respond_to do |format|
       format.html { redirect_to @tivit }
       format.js {}
       puts "[Yaniv] (pages controller)------->> after load_activities_tab Ajax."
    end   
  
end 

def home
    @title = "Home"
    
      
    current_user_id = current_account.user.get_id.to_s
 #ILAN - remove filter  
   # puts "current_user_id = "+current_user_id
   # puts "Sign in account = "+current_account.sign_in_count.to_s
    if(current_account.sign_in_count == 1 && !account_session[:show_help] == true )
      puts "befor render"
      render 'help'
      account_session[:show_help] = true
      return
    else

     
     
  # Filter only product On Deck (for now)

      @new_tivit_requests            = get_new_tivit_requests(current_user_id)
      @my_open_tasks                 = get_my_open_tasks(current_user_id)
      
      @activity_notification         = get_user_activity_notifications(current_user_id)           
 
    #  account_session[:filter_id] = @filter_id
     end
  end


  
  def myteam
    @title = "My Team"
  end
 
  def bireport
     @title = "Analytics"
     @user_adopt   = get_user_stats
     @tivit_stats  = get_tivits_stats
     @users = User.joins("LEFT OUTER JOIN accounts ON accounts.id = users.account_id").order(:current_sign_in_at,:created_at).reverse_order.paginate(:page => params[:page], :per_page => 30)
     
     #@active_users = User.where(:is_active => true)
     @active_users = User.joins(:account,:tivitcomments).where(:is_active => true).order("tivitcomments.updated_at").reverse_order.uniq
     #    users = User.joins(:tivitcomments).where("tivitcomments.activity_id = ? AND users.id = tivitcomments.user_id AND NOT tivitcomments.user_id = ? ",self.id, user.get_id)
       
  end

  def help
     @title = "How Does It Work?"
     
  end
  
  def people
     puts "in People controller"
     
     @title = "People I work with"
     @users  = current_account.user.mycontacts.joins(:account).order(:last_sign_in_at).reverse_order
     
  end
  
  def myaccount
     @title = "My Account"
  end
   
  def about
     @title = "About"
  end

end

