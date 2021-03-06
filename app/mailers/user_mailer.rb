require "socket"


class UserMailer < ActionMailer::Base
   default :from => "tiviti.mailer@tiviti.net",
           :bcc => "tiviti.mailer.cc@gmail.com"
   #   :return_path => 'system@example.com'
        
    def notify_new_user(params)
      @email    = params[:email]
      @action   = params[:type]
      mail(:from => "tiviti Admin",:reply_to => "no_reply@tiviti.net",:to => ["ilan.kasan@gmail.com","yanivlevi1@gmail.com"], :subject => "tiviti: "+ @action +" "+ @email)
                                                                                                      
   
    end 
   
   
   
   def notify_error_occured(params)
      
      mail(:from => "tiviti Admin",:reply_to => "no_reply@tiviti.net",:to => ["ilan.kasan@gmail.com","yanivlevi1@gmail.com"], :subject => "tiviti: Application ancountered ab error")
                                                                                                      
   
    end 
   
   
   
   def tivit_propose_new_date_email(params)
#107 Tivit - New Date Request. When: CAssignee requests alternate due date, Who: Assigner
    #  puts "--->>>>  tivit_propose_new_date_email"
    #  puts params.inspect
    #  puts "______________________________________"
           
      @assignee   = params[:assignee]
      @assigner   = params[:assigner]
      @tivit      = params[:tivit]
      @comment    = params[:comment]
      
          
      mail(:from => create_from_str(@assignee.get_name),:reply_to => @assignee.get_email,:to => @assigner.get_email,
           :subject => "tiviti: "+ @assignee.get_name+ " is requesting a different date for '"+@tivit.get_name+"'")
    end
   
   
   
   def tivit_accept_new_date_email(params)
     

#108  Tivit - New Date Accepted. When: Assigner accepts alternate due date, Who: Assignee
         
    @assignee   = params[:assignee]
    @assigner   = params[:assigner]
    @tivit      = params[:tivit]
    @comment    = params[:comment]
    
    mail(:from => create_from_str(@assigner.get_name),:reply_to => @assigner.get_email,:to => @assignee.get_email,
         :subject => "tiviti: "+ @assigner.get_name+ " accepted your proposed date for '"+@tivit.name+"'")
         
     
   end
   
   
   def new_tivit_email(params)
#101 Tivit - New. When: Assigner creates tivit, Who: Assignee
  #  puts "----------------------------------------"                                                   
  #  puts "really new "
  #  puts "----------------------------------------"                                                   
                                                      
    @invitee   = params[:assignee]
    @inviter   = params[:assigner]
    @tivit     = params[:tivit]
    
    mail(:from => create_from_str(@inviter.get_name),:reply_to => @inviter.get_email,:to => @invitee.get_email,
         :subject => "tiviti: "+@inviter.get_name+" needs your help with '"+@tivit.name+"'")
         
 #def old_new_tivit_email(assignee, assigner,tivit)
        
  end
    

 def notify_comment_added_to_tivit(params)
#103 Tivit - New Comment(s). When: Comment added (non-self), Who: Assigner, Assignee, Commenters  Ilan: sent only to asigner if asigne comments
    @commenter  = params[:commenter]
    @comment    = params[:comment]
    @tivit      = params[:tivit]
    toemail     = create_recipient_list(params[:send_to])
   # puts "sneding to "
    puts toemail.inspect
    mail(:from => create_from_str(@commenter.get_name),:reply_to => @commenter.get_email,:to => toemail,
         :subject => "tiviti: You have a new comment for '"+@tivit.get_name+"'" )
puts "<<<<<<<<<<<<    notify_comment_added_to_tivit "
    
 end

 
 #def reassign_tivit_old_owner(old_owner, new_owner,assigner, comment,tivit)
 def reassign_tivit_old_owner(params)

#112 Tivit - Reassign (Original Assigner). When: Assignee reassigns the tivit to another person. Who: Old Assignee, Activity owner
    @old_owner     = params[:old_owner]
    @new_owner     = params[:new_owner]
    @comment       = params[:comment]
    @tivit         = params[:tivit]
    @assigner      = params[:assigner]
    
    mail(:to => @assigner.get_email, :from => create_from_str(@old_owner.get_name),
         :subject => "tiviti: "+@old_owner.get_name+" asked "+@new_owner.get_name+" to help with '"+@tivit.get_name+"'")
         
  end

 #def reassign_tivit_new_owner(old_owner, new_owner, assigner, comment,  tivit)
 def reassign_tivit_new_owner(params)

#111 Tivit - Reassign. When: Assignee reassigns the tivit to another person. Who: New Assignee, Activity owner

   @old_owner      = params[:old_owner]
    @new_owner     = params[:new_owner]
    @comment       = params[:comment]
    @tivit         = params[:tivit]
    @assigner      = params[:assigner]
    
    
    mail(:to => @new_owner.get_email, :from => create_from_str(@old_owner.get_name),
         :subject => "tiviti: "+@old_owner.get_name+" needs your help with with '"+@tivit.get_name+"'")
          
  end

 
 
  def old_remind_user_to_review_tivit (user_reminding, message,tivit)
#112  Tivit - Remind. When: Assigner sends reminder, Who: Assignee
    @user_reminding     = user_reminding
    @tivit   			= tivit
    @message 			= message
    @assignee			= tivit.get_owner
    mail(:to => @assignee.get_email, 
         :subject =>"tiviti: "+user_reminding.get_name+" still needs your help with '"+tivit.name+"' !")
  end
  
  
def remind_user_to_review_tivit (params)
#112  Tivit - Remind. When: Assigner sends reminder, Who: Assignee
puts ": in reminder email" 
    @user_reminding = params[:user_reminding]
    @tivit          = params[:tivit]
    @message        = params[:message]
    @assignee       = params[:assignee]
    
    mail(:to => @assignee.get_email, :from => create_from_str(@user_reminding.get_name),
         :subject =>"tiviti: "+@user_reminding.get_name+" still needs your help with '"+@tivit.get_name+"' !")
         
  end
  

  def activity_completed_email(params)

#202 Activity - Closed. When Owner closes activity, Who: All Assignees
    @stakeholder     = params[:stakeholder]
    @comment         = params[:comment]
    @activity        = params[:activity]
    @activity_owner  = params[:activity_owner]
    puts "in activity_completed_email. sending to "+@stakeholder.get_email
    
    
  	mail(:from => create_from_str(@activity_owner.get_name),:to => @stakeholder.get_email,:reply_to => @activity_owner.get_email,
         :subject =>    "tiviti: "+@activity_owner.get_name+" says '"+@activity.name+"' is complete.  Thanks for your help!" )
  end
  
  
    def delete_old_activity_completed_email(stakeholder, comment,activity)

#202 Activity - Closed. When Owner closes activity, Who: All Assignees
    puts "in activity_completed_email. sending to "+stakeholder.get_email
    @stakeholder     = stakeholder
    @comment         = comment
    @activity        = activity
    @activity_owner  = activity.get_owner
    
    mail(:from => create_from_str(@activity_owner.get_name),:to => @stakeholder.get_email,:reply_to => @activity_owner.get_email,
         :subject =>    "tiviti: "+@activity_owner.get_name+" says '"+@activity.name+"' is complete.  Thanks for your help!" )
         
     
  end

  
      
  def tivit_done_email(params)
#106 Tivit- Complete. When: Completed Assignee changes status to "I'm done", Who: Assigner

    @assigner = params[:assigner]
    @assignee = params[:assignee]
    @comment  = params[:comment]
    @tivit    = params[:tivit]
    
    mail(:from => create_from_str(@assignee.get_name),:to => @assigner.get_email,:reply_to => @assignee.get_email,
         :subject => "tiviti: "+@assignee.get_name+" has completed '"+@tivit.get_name+"'!")     
  end
  
  
  def tivit_status_change_onit_email(params)
#105 Tivit - Started. When: Assignee changes status to "I'm on it", Who:  Assigner
 
    @assigner   = params[:assigner]
    @assignee   = params[:assignee]
    @tivit      = params[:tivit]
    @comment    = params[:comment]
 #   puts "---->>>> sending email to "+@assigner.get_email
    mail(:from => create_from_str(@assignee.get_name),:to => @assigner.get_email,:reply_to => @assignee.get_email,
         :subject => "tiviti: "+@assignee.get_name+" has accepted your request for help with '"+@tivit.get_name+"'" )
     
  end
 
  
 
  
 def tivit_decline_email(params)
#110 Tivit - Decline. When: Assignee changes status to "I'm too busy", Who:  Assigner
 
    @assignee    = params[:assignee]
    @tivit       = params[:tivit]
    @comment     = params[:comment]
    @assigner    = params[:assigner]
    
    #puts "---->>>> sending email to "+@assigner.get_email
    mail(:from => create_from_str(@assignee.get_name),:to => @assigner.get_email,:reply_to => @assignee.get_email,
         :subject => "tiviti: "+@assignee.get_name+" isn't able to work on '"+@tivit.get_name+"'" )
  end
  
  def delete_user_tivit_status_change_email(user, action,comment,tivit)
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
