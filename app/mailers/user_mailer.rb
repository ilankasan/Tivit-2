require "socket"
class UserMailer < ActionMailer::Base
   default :from => "tiviti.mailer@gmail.com"
   #//:url =>"http://"+Socket.gethostname
  def welcome_email(user)
    @user = user
    @url  = "http://tiviti.heroku.com"
    
    mail(:to => user.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => "Welcome to tiviti!")
  end
  
  
  def new_tivit_email(invitee, owner,tivit)
    @invitee = invitee
    @owner   = owner
    @tivit   = tivit
	@url  = "http://tiviti.heroku.com"
    
    mail(:to => invitee.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => "New tivit!")
  end
  
  
  def user_tivit_status_change_done_email(user, comment,tivit)
    @owner    = tivit.get_owner
    @user     = user
    @comment  = comment
    @tivit    = tivit
    @url  	  = "http://tiviti.heroku.com"
  	
  	mail(:to => @owner.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.name+" completed their share in the tivit '"+tivit.name+"'" )
  end
  
  def user_tivit_status_change_email(user, action,comment,tivit)
    @owner    = tivit.get_owner
    @user     = user
    @action   = action
    @comment  = comment
    @tivit    = tivit
    @url  	  = "http://tiviti.heroku.com"
    
    
	#@url  = "http://"+Socket.gethostname+Socket.ip_address_list
	  
    mail(:to => @owner.email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.name+" has "+ action + " tivit '"+tivit.name+"'" )
  end
  
  
end
