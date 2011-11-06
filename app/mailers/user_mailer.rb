require "socket"
class UserMailer < ActionMailer::Base
   default :from => "tiviti.mailer@gmail.com"
   #//:url =>"http://"+Socket.gethostname
  	
   def new_tivit_email(invitee, inviter,tivit)
#101 Tivit - New. When: Assigner creates tivit, Who: Assignee
                                                      
    @invitee   = invitee
    @inviter   = inviter
    @tivit     = tivit
    
    mail(:to => invitee.get_email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => "Tiviti:"+ inviter.get_name + " needs your help with "+tivit.name)
         
  end


 def notify_comment_added_to_tivit(commenter, comment,activity, send_to)
#103 Tivit - New Comment(s). When: Comment added (non-self), Who: Assigner, Assignee, Commentors  Ilan: sent only to asigner if asigne comments

    @user     = commenter
    @comment  = comment
    @tivit    = activity
    
    toemail = send_to[0].get_email
    mail(:to => toemail, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.get_name+" left a commented on '"+@tivit.name+"'" )
  end

 
 def reassign_tivit(old_owner, new_owner, comment,tivit)
#111 Tivit - Reassign. When: Assignee reassigns the tivit to another person. Who: New Assignee, Activity owner

    @old_owner     = old_owner
    @new_owner     = new_owner
    @comment       = comment
    @tivit         = tivit
    senlist = create_recipient_list([@new_owner,tivit.get_parent.get_owner])
    mail(:to => senlist, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @old_owner.get_name+" needs your help with "+"'"+@tivit.get_parent.name+"'" )
  end

 
 
  def remind_user_to_review_tivit (user_reminding, message,tivit)
#112  Tivit - Remind. When: Assigner sends reminder, Who: Assignee

    @user_reminding     = user_reminding
    @tivit   			= tivit
    @message 			= message
    invitees			= tivit.get_owner.get_email
    
    mail(:to => invitees, :cc => "tiviti.mailer.cc@gmail.com",
         :subject =>"REMINDER: Please review my request for your help with " +tivit.name)  
  end
  
  
  def activity_status_completed_email (user, invitees,summary,tivit)
#202 Activity - Closed. When: Owner closes activity, Who: All Assignees
#ilan: change email name from tivit to activity
    @user    = user
    @tivit   = tivit
    @summary = summary
    
    mail(:to => invitees, :cc => "tiviti.mailer.cc@gmail.com,"+user.get_email,
         :subject =>"tivit" +" '"+tivit.name+"' " + "is completed!" )  
  end 

  def activity_completed_email(user, comment,activity)
#ilan: not sure this is in use.
#202 Activity - Closed. When Owner closes activity, Who: All Assignees

    @user     = user
    @comment  = comment
    @activity = activity
    
  	mail(:to => @user.get_email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @activity.get_owner.name+" closed activity '"+activity.name+"'" )
  end
  
  
  def user_tivit_status_change_done_email(user, comment,tivit)
#106 Tivit- Complete. When: Completed Assignee changes status to "I'm done", Who: Assigner

    @owner    = tivit.get_owner
    @user     = user
    @comment  = comment
    @tivit    = tivit
    
  	mail(:to => @tivit.get_parent.get_owner.get_email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.name+" completed their tivit '"+tivit.name+"'" + "in Activity "+@tivit.get_parent.name )
  end
  
  
  
  def user_tivit_status_change_onit_email(user, comment,tivit)
#105 Tivit - Started. When: Assignee changes status to "I'm on it", Who:  Assigner
 
    @inviter    = tivit.get_invited_by
    @invitee    = user
    @tivit      = tivit
    @comment    = comment
    
    mail(:to => @inviter.get_email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @invitee.name+" has started tivit '"+tivit.name+"'" )
  
  end
  
  def user_tivit_status_change_email(user, action,comment,tivit)
    @invited_by    = tivit.get_invited_by
    @user     	   = user
    @action        = action
    @comment       = comment
    @tivit         = tivit
     
    mail(:to => @invited_by.get_email, :cc => "tiviti.mailer.cc@gmail.com",
         :subject => @user.name+" has "+ action + " tivit '"+tivit.name+"'" )
         
  end
 
 
private
  def create_recipient_list(users)
    str = []
    users.each do |user|
      str << user.get_email
    end
    return str
    
  end
  
end
