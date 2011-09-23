require "socket"
class UserMailer < ActionMailer::Base
   default :from => "tiviti.mailer@gmail.com"
   #//:url =>"http://"+Socket.gethostname
  	
  
  def welcome_email(user)
    @user = user
    @url     = "http://tiviti.heroku.com" # ilan: need to pass url dynamically or through a config file
    
    mail(:to => user.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => "Welcome to tiviti!")
  end
  
  
  
  def user_tivit_status_completed_email (user, invitees,summary,tivit)
    @user    = user
    @tivit   = tivit
    @summary = summary
    @url     = "http://tiviti.heroku.com"
    
    mail(:to => invitees, :cc => "tiviti.mailer.cc@gmail.com,"+user.email,
         :subject =>"tivit" +" '"+tivit.name+"' " + "is completed!" )  
  end
  
  
  def new_tivit_email(invitee, owner,tivit)
    @invitee = invitee
    @owner   = owner
    @tivit   = tivit
	@url  = "http://tiviti.heroku.com"
    
    mail(:to => invitee.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @owner.get_name+ " needs your help with "+tivit.get_parent.name)
  end


  def user_activity_status_change_done_email(user, comment,activity)
    @owner    = activity.get_owner
    @user     = user
    @comment  = comment
    @activity = activity
    @url  	  = "http://tiviti.heroku.com"
  	
  	mail(:to => @owner.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.name+" closed activity '"+activity.name+"'" )
  end
  
  
  def user_tivit_status_change_done_email(user, comment,tivit)
    @owner    = tivit.get_owner
    @user     = user
    @comment  = comment
    @tivit    = tivit
    @url  	  = "http://tiviti.heroku.com"
  	
  	mail(:to => @tivit.get_parent.get_owner.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.name+" completed their tivit '"+tivit.name+"'" + "in Activity "+@tivit.get_parent.name )
  end
  
  
  
  
  def user_tivit_status_change_email(user, action,comment,tivit)
    @owner    = tivit.get_owner
    @user     = user
    @action   = action
    @comment  = comment
    @tivit    = tivit
    @url  	  = "http://tiviti.heroku.com"
    
     
    mail(:to => @owner.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.name+" has "+ action + " tivit '"+tivit.name+"'" )
  end
  
  
end
