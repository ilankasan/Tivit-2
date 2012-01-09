require "socket"


class UserMailer < ActionMailer::Base
   default :from => "tiviti.mailer@tiviti.net",
           :bcc => "tiviti.mailer.cc@gmail.com"
   #   :return_path => 'system@example.com'
        
   
  def old_dispatcher(params)
    puts ">>>>>>>>>>>> email dispatcher 6666664444444444"
  #  puts params.inspect
    
    #self.new_tivit_email(params[:assignee], params[:assigner],params[:tivit]).deliver
   # self.send(params[:email_type],params[:assignee], params[:assigner],params[:tivit]).deliver
    
   
    #puts *params.inspect
    #self.send(params[:email_type],params[:assignee], params[:assigner],params[:tivit]).deliver
    self.new_tivit_email(params[:assignee], params[:assigner],params[:tivit]).deliver
    
    
    #self.send(params[:email_type],params).deliver
    #self.new_tivit_email(params).deliver
   
    
    
    puts "<<<<<<<<<<<< email dispatcher 6666666644444444" 
    
  #  case test
  #  when ("new_tivit") # On Deck
      #  @tivits_ondeck             = get_activities_i_participate(current_user_id)
              
   #   when ("2") # my activities
    #    puts "show my activities"
     #   @tivits_ondeck             = get_my_activities(current_user_id)
        
    #  else
     # end
# 
  end


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
   
   
   def new_tivit_email(params)
#101 Tivit - New. When: Assigner creates tivit, Who: Assignee
    puts "----------------------------------------"                                                   
    puts "really new "
    puts "----------------------------------------"                                                   
                                                      
    @invitee   = params[:assignee]
    @inviter   = params[:assigner]
    @tivit     = params[:tivit]
    
    mail(:from => create_from_str(@inviter.get_name),:reply_to => @inviter.get_email,:to => @invitee.get_email,
         :subject => "tiviti: "+@inviter.get_name+" needs your help with "+@tivit.name)
         
 #def old_new_tivit_email(assignee, assigner,tivit)
        
  end
    

 def notify_comment_added_to_tivit(params)
#103 Tivit - New Comment(s). When: Comment added (non-self), Who: Assigner, Assignee, Commenters  Ilan: sent only to asigner if asigne comments
puts ">>>>>>>>>>    notify_comment_added_to_tivit "
    @commenter  = params[:commenter]
    @comment    = params[:comment]
    @tivit      = params[:tivit]
    toemail     = create_recipient_list(params[:send_to])
    
    mail(:from => create_from_str(@commenter.get_name),:reply_to => @commenter.get_email,:to => toemail,
         :subject => "tiviti: You have a new comment for '"+@tivit.get_name+"'" )
puts "<<<<<<<<<<<<    notify_comment_added_to_tivit "
    
 end


def old_notify_comment_added_to_tivit(commenter, comment,tivit, send_to)
#103 Tivit - New Comment(s). When: Comment added (non-self), Who: Assigner, Assignee, Commenters  Ilan: sent only to asigner if asigne comments

    @commenter  = commentor
    @comment    = comment
    @tivit      = tivit
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
    @assignee			= tivit.get_owner
    
    mail(:to => @assignee.get_email, 
         :subject =>"tiviti: "+user_reminding.get_name+" still needs your help with "+tivit.name+" !")
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
