require "socket"
class UserMailer < ActionMailer::Base
   default :from => "tiviti.mailer@tiviti.net"
        #   :return_path => 'system@example.com'
   
   def new_tivit_email(assignee, assigner,tivit)
#101 Tivit - New. When: Assigner creates tivit, Who: Assignee
                                                      
    @invitee   = assignee
    @inviter   = assigner
    @tivit     = tivit
    
    mail(:from => assigner.get_name+" via tiviti",:reply_to => assigner.get_email,:to => assignee.get_email, :bcc => "tiviti.mailer.cc@gmail.com",
         :subject => "tiviti: "+assigner.get_name+" needs your help with "+tivit.name)
         
         
  end


 def notify_comment_added_to_tivit(commentor, comment,activity, send_to)
#103 Tivit - New Comment(s). When: Comment added (non-self), Who: Assigner, Assignee, Commenters  Ilan: sent only to asigner if asigne comments

    @commenter  = commentor
    @comment    = comment
    @tivit      = activity
    toemail     = create_recipient_list(send_to)
    
    mail(:from => commentor.get_name+" via tiviti",:reply_to => commentor.get_email,:to => toemail, :bcc => "tiviti.mailer.cc@gmail.com",
         :subject => "tiviti: You have a new comment for '"+@tivit.name+"'" )
    
 end

 
 def reassign_tivit(old_owner, new_owner, comment,tivit)
#111 Tivit - Reassign. When: Assignee reassigns the tivit to another person. Who: New Assignee, Activity owner

    @old_owner     = old_owner
    @new_owner     = new_owner
    @comment       = comment
    @tivit         = tivit
    senlist = create_recipient_list([@new_owner,tivit.get_parent.get_owner])
    mail(:to => senlist, :bcc => "tiviti.mailer.cc@gmail.com",
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
    
    mail(:to => invitees, :bcc => "tiviti.mailer.cc@gmail.com,"+user.get_email,
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
  
  
  def user_tivit_status_change_done_email(user, activity_owner, comment,tivit)
#106 Tivit- Complete. When: Completed Assignee changes status to "I'm done", Who: Assigner

    @assigner = activity_owner
    @assignee = user
    @comment  = comment
    @tivit    = tivit
    mail(:to => activity_owner.get_email, :bcc => "tiviti.mailer.cc@gmail.com",
         :subject => "tiviti: "+@assignee.get_name+" has completed "+tivit.name+"!")     
  end
  
  
  def tivit_status_change_onit_email(assignee, comment,tivit)
#105 Tivit - Started. When: Assignee changes status to "I'm on it", Who:  Assigner
 
    @assigner    = tivit.get_invited_by
    @assignee   = assignee
    @tivit      = tivit
    @comment    = comment
    puts "---->>>> sending email to "+@assigner.get_email
    mail(:to => @assigner.get_email, :bcc => "tiviti.mailer.cc@gmail.com",:from => assignee.get_name+" via tiviti",:reply_to => assignee.get_email
         :subject => "tiviti: "+@assignee.name+" has accepted your request for help with '"+tivit.name+"'" )
     
  end
  
  def user_tivit_status_change_email(user, action,comment,tivit)
    @invited_by    = tivit.get_invited_by
    @user     	   = user
    @action        = action
    @comment       = comment
    @tivit         = tivit
     
    mail(:to => @invited_by.get_email, :bcc => "tiviti.mailer.cc@gmail.com",
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
