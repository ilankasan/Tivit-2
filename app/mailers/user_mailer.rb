require "socket"
class UserMailer < ActionMailer::Base
   default :from => "tiviti.mailer@tiviti.net",
           :bcc => "tiviti.mailer.cc@gmail.com"
   #   :return_path => 'system@example.com'
        
   
   def tivit_propose_new_date_email(assignee, assigner, tivit,comment )
#107 Tivit - New Date Request. When: CAssignee requests alternate due date, Who: Assigner
    puts "tivit_propose_new_date_email"
         
    @assignee   = assignee
    @assigner   = assigner
    @tivit      = tivit
    @comment    = comment
    
        
    mail(:from => create_from_str(assignee.get_name),:reply_to => assignee.get_email,:to => assigner.get_email,
         :subject => "tiviti: "+ assignee.get_name+ " is requesting a different date for "+tivit.name)
         
     
   end
   
   def tivit_accept_new_date_email(assignee, assigner, tivit,comment )
#108  Tivit - New Date Accepted. When: Assigner accepts alternate due date, Who: Assignee
    puts "tivit_access_new_date_email"
         
    @assignee   = assignee
    @assigner   = assigner
    @tivit      = tivit
    @comment    = comment
    
    mail(:from => create_from_str(assigner.get_name),:reply_to => assigner.get_email,:to => assignee.get_email,
         :subject => "tiviti: "+ assigner.get_name+ " accepted your proposed date for "+tivit.name)
         
     
   end
   
   
   def new_tivit_email(assignee, assigner,tivit)
#101 Tivit - New. When: Assigner creates tivit, Who: Assignee
                                                      
    @invitee   = assignee
    @inviter   = assigner
    @tivit     = tivit
    
    mail(:from => create_from_str(assigner.get_name),:reply_to => assigner.get_email,:to => assignee.get_email,
         :subject => "tiviti: "+assigner.get_name+" needs your help with "+tivit.name)
         
         
  end


 def notify_comment_added_to_tivit(commentor, comment,activity, send_to)
#103 Tivit - New Comment(s). When: Comment added (non-self), Who: Assigner, Assignee, Commenters  Ilan: sent only to asigner if asigne comments

    @commenter  = commentor
    @comment    = comment
    @tivit      = activity
    toemail     = create_recipient_list(send_to)
    
    mail(:from => create_from_str(commentor.get_name),:reply_to => commentor.get_email,:to => toemail,
         :subject => "tiviti: You have a new comment for '"+@tivit.name+"'" )
    
 end

 
 def reassign_tivit(old_owner, new_owner, comment,tivit)
#111 Tivit - Reassign. When: Assignee reassigns the tivit to another person. Who: New Assignee, Activity owner

    @old_owner     = old_owner
    @new_owner     = new_owner
    @comment       = comment
    @tivit         = tivit
    senlist = create_recipient_list([@new_owner,tivit.get_parent.get_owner])
    mail(:to => senlist, 
         :subject => @old_owner.get_name+" needs your help with "+"'"+@tivit.get_parent.name+"'" )
  end

 
 
  def remind_user_to_review_tivit (user_reminding, message,tivit)
#112  Tivit - Remind. When: Assigner sends reminder, Who: Assignee

    @user_reminding     = user_reminding
    @tivit   			= tivit
    @message 			= message
    invitees			= tivit.get_owner.get_email
    
    mail(:to => invitees, 
         :subject =>"REMINDER: Please review my request for your help with " +tivit.name)  
  end
  
  
  def OLD_activity_status_completed_email (owner, invitees,summary,activity)
#202 Activity - Closed. When: Owner closes activity, Who: All Assignees
#ilan: change email name from tivit to activity
puts "sending completed email"
    @user    = user
    @tivit   = activity
    @summary = summary
    
    mail(:to => invitees, 
         :subject =>    "tiviti: "+owner.get_name+" says "+activity.name+" is complete.  Thanks for your help!" )  
  end 

  def activity_completed_email(user, comment,activity)

#202 Activity - Closed. When Owner closes activity, Who: All Assignees
puts "in activity_completed_email. sending to "+user.get_email
    @user     = user
    @comment  = comment
    @activity = activity
    @owner    = activity.get_owner
    
  	mail(:from => create_from_str(@owner.get_name),:to => @user.get_email,:reply_to => @owner.get_email,
         :subject =>    "tiviti: "+@owner.get_name+" says "+activity.name+" is complete.  Thanks for your help!" )
     
  end
  
  
  def user_tivit_status_change_done_email(assignee, assigner, comment,tivit)
#106 Tivit- Complete. When: Completed Assignee changes status to "I'm done", Who: Assigner

    @assigner = assigner
    @assignee = assignee
    @comment  = comment
    @tivit    = tivit
    mail(:from => create_from_str(assignee.get_name),:to => assigner.get_email,:reply_to => assignee.get_email,
         :subject => "tiviti: "+@assignee.get_name+" has completed "+tivit.name+"!")     
  end
  
  
  
  
  def tivit_status_change_onit_email(assignee, comment,tivit)
#105 Tivit - Started. When: Assignee changes status to "I'm on it", Who:  Assigner
 
    @assigner    = tivit.get_invited_by
    @assignee   = assignee
    @tivit      = tivit
    @comment    = comment
    puts "---->>>> sending email to "+@assigner.get_email
    mail(:from => create_from_str(assignee.get_name),:to => @assigner.get_email,:reply_to => assignee.get_email,
         :subject => "tiviti: "+@assignee.name+" has accepted your request for help with '"+tivit.name+"'" )
     
  end
 
 def tivit_decline_email(assignee, comment,tivit)
#110 Tivit - Decline. When: Assignee changes status to "I'm too busy", Who:  Assigner
 
    @assigner    = tivit.get_invited_by
    @assignee   = assignee
    @tivit      = tivit
    @comment    = comment
    puts "---->>>> sending email to "+@assigner.get_email
    mail(:from => create_from_str(assignee.get_name),:to => @assigner.get_email,:reply_to => assignee.get_email,
         :subject => "tiviti: "+@assignee.name+" isn't able to work on '"+tivit.name+"'" )
  end
  
 
  
  
  
  def user_tivit_status_change_email(user, action,comment,tivit)
    @invited_by    = tivit.get_invited_by
    @user     	   = user
    @action        = action
    @comment       = comment
    @tivit         = tivit
     
    mail(:to => @invited_by.get_email, 
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
  
  
  def create_from_str(name)
    return name+" via tiviti"
  end
  
end
