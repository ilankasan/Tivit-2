require "socket"
class UserMailer < ActionMailer::Base
   default :from => "tiviti.mailer@gmail.com"
   #//:url =>"http://"+Socket.gethostname
  	
  
 
  def remind_user_to_review_tivit (user_reminding, message,tivit)
  	
    @user_reminding     = user_reminding
    @tivit   			= tivit
    @message 			= message
    @url     			= "http://tiviti.heroku.com"
    invitees			= tivit.get_owner.get_email
    
    mail(:to => invitees, :cc => "tiviti.mailer.cc@gmail.com",
         :subject =>"REMINDER: Please review my request for your help with " +tivit.name)  
  end
  
  
  def user_tivit_status_completed_email (user, invitees,summary,tivit)
    @user    = user
    @tivit   = tivit
    @summary = summary
    @url     = "http://tiviti.heroku.com"
    
    mail(:to => invitees, :cc => "tiviti.mailer.cc@gmail.com,"+user.get_email,
         :subject =>"tivit" +" '"+tivit.name+"' " + "is completed!" )  
  end
  
  
  def new_tivit_email(invitee, inviter,tivit)
    @invitee   = invitee
    @inviter   = inviter
    @tivit     = tivit
	@url       = "http://tiviti.heroku.com"
    puts "to  email  "+ invitee.get_email
    mail(:to => invitee.get_email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => inviter.get_name + " needs your help with "+tivit.get_parent.name)
  end



  def notify_comment_added_to_tivit(commenter, comment,activity, send_to)
    @user     = commenter
    @comment  = comment
    @tivit    = activity
    @url  	  = "http://tiviti.heroku.com"
  	puts " SENDING  EMAIL to " + send_to[0].get_email
  	puts @comment.inspect
  	toemail = send_to[0].get_email
  	mail(:to => toemail, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.get_name+" left a commented on '"+@tivit.name+"'" )
  end
  

  def user_activity_status_change_done_email(user, comment,activity)
    @owner    = activity.get_owner
    @user     = user
    @comment  = comment
    @activity = activity
    @url  	  = "http://tiviti.heroku.com"
  	
  	mail(:to => @owner.get_email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.name+" closed activity '"+activity.name+"'" )
  end
  
  
  def user_tivit_status_change_done_email(user, comment,tivit)
    @owner    = tivit.get_owner
    @user     = user
    @comment  = comment
    @tivit    = tivit
    @url  	  = "http://tiviti.heroku.com"
  	
  	mail(:to => @tivit.get_parent.get_owner.get_email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.name+" completed their tivit '"+tivit.name+"'" + "in Activity "+@tivit.get_parent.name )
  end
  
  
  
  
  def user_tivit_status_change_email(user, action,comment,tivit)
    @invited_by    = tivit.get_invited_by
    @user     	   = user
    @action        = action
    @comment       = comment
    @tivit         = tivit
    @url  	       = "http://tiviti.heroku.com"
    
     
    mail(:to => @invited_by.get_email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.name+" has "+ action + " tivit '"+tivit.name+"'" )
  end
  
  
end
