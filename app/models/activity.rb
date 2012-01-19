class Activity < ActiveRecord::Base
  
  attr_accessible :name, :description, :status, :due,:invited_by,:owner_id, :users, :completed_at, :summary,:activity_type, :parent_id,:activity_name, :documents, :parent
  validates :name, :presence => true
# each Tivit has many participants
  has_and_belongs_to_many :users
  has_and_belongs_to_many :documents
  
  has_one :parent, :class_name => "Activity", :primary_key => "parent_id", :foreign_key => "id"
  
  

# each tivit has many comments
  has_many :tivitcomments

# each tivit has many user status (show the specific status for each user)
  has_many :tivit_user_statuses
  
  
  has_many :tivits, :class_name => "Activity",
    :foreign_key => "parent_id"

  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :description, :length => { :maximum => 1024 }
  validates :owner_id, :presence => true
  validates :activity_type, :presence => true, :length => { :maximum => 140 }
  
  
  validates_inclusion_of :activity_type, :in => %w(activity tivit),
    :message => "%{value} is not a valid activity type"

# an activity or a tivit have two statuses. In progress or Completed.
  validates_inclusion_of :status, :in => %w(in-progress Completed),
    :message => "%{value} is not a valid status"


  default_scope :order => 'activities.due DESC'
  
  def get_name
   return self.name
  end
  
  def get_due_date
    return self.due
  end
# Update status of the users invites to he activity
  
  def get_description
    return self.description
  end
  
  
  
  def add_user_invitee(user)
 #adding the user to the existing users on the task
    self.users << user
# sending invitee an email invite
# owner = self.get_owner
    self.update_user_tivit_status(user)

#ilan: not 100% we ned the save option

  end

  def invitedByOwner?
   return (self.invited_by == self.get_parent.get_owner.id)
  end

  def isActivity?
   return self.activity_type == "activity"
  end
  
  def get_parent
  #  puts "^^^^^^ in get parent ^^^^^^^"
   return parent
  end


  def get_parent_owner
  #  puts "^^^^^^ in get parent ^^^^^^^"
   if(parent != nil)
    return parent.get_owner
   else
     return nil
   end
      
  end


  def self.get_num_of_incoming_tivits(currentuser)
# Returns tivits i own and required my response or in play (awaiting the assiger to response with my proposal).
   results = self.joins(:tivit_user_statuses).where(
                  "       activities.owner_id         = ? 
                  AND     tivit_user_statuses.user_id = activities.owner_id
                  AND NOT activities.activity_type    = 'activity' 
                  AND     activities.id               = tivit_user_statuses.activity_id 
                  AND     (tivit_user_statuses.status_id = 'New' OR tivit_user_statuses.status_id = 'Reviewed')",currentuser.id).count
 
   return results
#   results = self.joins(:tivit_user_statuses).where(
 #                 "       activities.owner_id         = ? 
  #                AND     tivit_user_statuses.user_id = activities.owner_id
   #               AND NOT activities.activity_type    = 'activity' 
    #              AND     activities.id               = tivit_user_statuses.activity_id 
     #             AND     ((NOT tivit_user_statuses.status_id = 'Done') AND (NOT tivit_user_statuses.status_id = 'OnIt' )) ",currentuser.id).count
    #return 2 
  end




#return a unique array of all users who commented on this tivit
   def get_all_tivit_commenters_excluding_user (user)
# Ilan: This code can be improved by using a distinct SQL command
#return array of users excluding user
     users = User.joins(:tivitcomments).where("tivitcomments.activity_id = ? AND users.id = tivitcomments.user_id AND NOT tivitcomments.user_id = ? ",self.id, user.get_id)
   #  puts "users = "+users.inspect
     users = users.uniq
     return users
   end
   

  def get_open_or_recently_done_tivits
self.tivits.joins(:tivit_user_statuses).where("tivit_user_statuses.user_id = activities.owner_id
AND ((NOT tivit_user_statuses.status_id = 'Done')
OR ((tivit_user_statuses.status_id = 'Done' AND tivit_user_statuses.last_status_change > ?)))",Time.now-1.day)
  end
  
  
  def get_all_my_tivits (user)
    self.tivits.where(:owner_id => user.get_id)
  end
  
  def get_last_reviewed (user)
    
    tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
    if(tivit_user_status == nil )
      last_reviewed = Time.now
    else
      last_reviewed = tivit_user_status.last_reviewed
    end
    puts "Last Reviewed = "+last_reviewed.to_s
    if(last_reviewed.to_s.empty?)
        
        puts "--------------- last review is not empty ------------- "+last_reviewed.to_s
        last_reviewed = Time.now()
        last_reviewed = last_reviewed - 1000000000
        puts "--------------- last review is not empty ------------- "+last_reviewed.to_s

    end
    return last_reviewed
  end
  
  def get_on_deck_tivits (user)
   # puts "On deck filter!"
    last_reviewed = get_last_reviewed (user)
    
#My Activities
#Always show all my Activites that are not closed - so I could close it
#Show the following tivits in each activity:
#Not completed (basically everything that is not yet completed - on it, in progress, late, etc.)
#Completed that had new comments on it

#Other's activity:
#Only show the activity if I have a tivit there and it's not completed yet.
#If I completed all my tivits in others activity, only show it if other tivits
#I participated in the discussion had new comments or someone commented it my tivit.
#Otherwise, don't show the activity at all.
#My tivits should show up at the top
#Only show other team tivits IF I ever participated in the discussion and there's a status change or new comment there
#Don't show closed/completed activities

    
    if(self.owner_id == user.get_id)
#activity owned by user
      puts "user is the owner of activity"
      
      all_open_tivits = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done'
AND tivit_user_statuses.user_id = activities.owner_id").order(:due).reverse_order
         
      puts "Open tivits size "+all_open_tivits.size.to_s
      

        closed_tivits_with_comments = self.tivits.joins(:tivitcomments).where("tivitcomments.activity_id = activities.id
AND tivitcomments.created_at > ?
AND NOT tivitcomments.user_id = ?",last_reviewed, user.get_id)
         
      puts "closed_tivits_with_comments size "+closed_tivits_with_comments.size.to_s
      return (all_open_tivits + closed_tivits_with_comments).uniq
   
    else
# User is not the owner of the activity
      puts "----------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user is NOT the owner of activity"
      
# Get only my open tivits and tivits i am the invitee (asignee)
      my_open_tivits = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done'
AND activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id",user.get_id).order(:due).reverse_order
       
      open_tivits_im_asignee = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done'
AND activities.invited_by = ? AND tivit_user_statuses.user_id = activities.owner_id",user.get_id)
      puts "Open invited by "+open_tivits_im_asignee.size.to_s
      
# get all tivits i participated in the conversation and there are new comments
# need to add the case i am the asignee
       
    sql = "SELECT DISTINCT tivits.* FROM activities as tivits, tivitcomments as mycomments , tivitcomments as othercomments
            WHERE tivits.activity_type      = 'tivit'
              AND tivits.parent_id          = "+self.id.to_s+"
              AND mycomments.activity_id    = tivits.id
              AND mycomments.user_id        = "+user.get_id.to_s+"
              AND othercomments.activity_id = tivits.id
              AND othercomments.created_at  > ?
              AND NOT othercomments.user_id = "+user.get_id.to_s+"
              ORDER BY tivits.due"
                 
        tivits_i_commented_with_new_comments = Activity.find_by_sql([sql,last_reviewed])
        
    #    puts "tivits_i_commented_with_new_comments "+tivits_i_commented_with_new_comments.size.to_s
     #   puts "my open tivites "+my_open_tivits.size.to_s
                 
      return (tivits_i_commented_with_new_comments + my_open_tivits+open_tivits_im_asignee).uniq
    end
    
puts "-------------<<<<<<<<<<<<<<"
       
  end
  
  
  
  def new_get_on_deck_tivits (user)
    puts "------------->>>>>>>>>>>>"
    puts "On deck filter!"
    last_reviewed = get_last_reviewed (user)
    

    
    if(self.owner_id == user.get_id)
#activity owned by user
      puts "user is the owner of activity"
      
      all_open_tivits = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done'
AND tivit_user_statuses.user_id = activities.owner_id")
         
     # puts "_______________________________________________________________________________________"
      puts "Open tivits size "+all_open_tivits.size.to_s
      

        closed_tivits_with_comments = self.tivits.joins(:tivitcomments).where("tivitcomments.activity_id = activities.id
AND tivitcomments.created_at > ?
AND NOT tivitcomments.user_id = ?",last_reviewed, user.get_id)
         
      puts "closed_tivits_with_comments size "+closed_tivits_with_comments.size.to_s
      return (all_open_tivits + closed_tivits_with_comments).uniq
   
    else
# User is not the owner of the activity
      puts "----------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user is NOT the owner of activity"
      
# Get only my open tivits and tivits i am the invitee (asignee)
      my_open_tivits = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done'
AND activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id",user.get_id)
       
      open_tivits_im_asignee = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done'
AND activities.invited_by = ? AND tivit_user_statuses.user_id = activities.owner_id",user.get_id)
      puts "Open invited by "+open_tivits_im_asignee.size.to_s
         
      
# get all tivits i participated in the conversation and there are new comments
# need to add the case i am the asignee
       
    sql = "SELECT DISTINCT tivits.* FROM activities as tivits, tivitcomments as mycomments , tivitcomments as othercomments
WHERE tivits.activity_type = 'tivit'
AND tivits.parent_id = "+self.id.to_s+"
AND mycomments.activity_id = tivits.id
AND mycomments.user_id = "+user.get_id.to_s+"
AND othercomments.activity_id = tivits.id
AND othercomments.created_at > ?
AND NOT othercomments.user_id = "+user.get_id.to_s+"
ORDER BY tivits.due"
                 
        tivits_i_commented_with_new_comments = Activity.find_by_sql([sql,last_reviewed])
        
        puts "tivits_i_commented_with_new_comments "+tivits_i_commented_with_new_comments.size.to_s
        puts "my open tivites "+my_open_tivits.size.to_s
                 
      return (tivits_i_commented_with_new_comments + my_open_tivits+open_tivits_im_asignee).uniq
    end
  end

  def get_requests_tivits(currentuser)
# retuen my new requests  
   my_tivits    = self.tivits.joins(:tivit_user_statuses).where("tivit_user_statuses.user_id = activities.owner_id 
       AND   activities.owner_id     = ? AND NOT activities.invited_by = ? AND  (tivit_user_statuses.status_id = 'New' OR tivit_user_statuses.status_id = 'Reviewed')",currentuser.id,currentuser.id)
   puts " number of my new requests "+my_tivits.length.to_s
             
   other_tivits = self.tivits.joins(:tivit_user_statuses).where("tivit_user_statuses.user_id = activities.owner_id 
       AND   NOT activities.owner_id = ? AND activities.invited_by = ? AND (tivit_user_statuses.status_id = 'Proposed' OR tivit_user_statuses.status_id = 'Decline')",currentuser.id,currentuser.id)
             
    puts " number of  requests nee my action "+other_tivits.length.to_s          
   
    return my_tivits + other_tivits
  end
  
  
  
  def self.get_num_of_requests_tivits(currentuser)
    current_user_id = currentuser.get_id.to_s
    sql_activities_with_my_tivits = "SELECT DISTINCT tivits.* FROM activities, activities as tivits, tivit_user_statuses 
                   WHERE NOT activities.status        = 'Completed'  
                   AND  activities.activity_type      = 'activity' 
                   AND  tivits.owner_id               = "+current_user_id+"
                   AND  NOT tivits.invited_by         = "+current_user_id+"   
                   AND  tivits.parent_id              = activities.id  
                   AND  tivits.owner_id               = tivit_user_statuses.user_id 
                   AND  tivits.id                     = tivit_user_statuses.activity_id 
                   AND  (tivit_user_statuses.status_id = 'New' OR tivit_user_statuses.status_id = 'Reviewed')
                   ORDER BY activities.due"
    
     results1  =  Activity.find_by_sql(sql_activities_with_my_tivits).count
     puts " number of my new requests "+results1.to_s
             
   
      
     sql_activities_i_assigned_with_tivit_requests = "SELECT DISTINCT tivits.* FROM activities, activities as tivits, tivit_user_statuses 
                   WHERE NOT activities.status           = 'Completed'  
                   AND     activities.activity_type      = 'activity'
                   AND NOT tivits.owner_id               = "+current_user_id+"
                   AND     tivits.invited_by             = "+current_user_id+"   
                   AND     tivits.parent_id              = activities.id  
                   AND     tivits.owner_id               = tivit_user_statuses.user_id 
                   AND     tivits.id                     = tivit_user_statuses.activity_id 
                   AND  ( tivit_user_statuses.status_id  = 'Declined' OR tivit_user_statuses.status_id  = 'Proposed')
                   ORDER BY activities.due"
    #AND     activities.owner_id           = "+current_user_id+"  
                   
                 
      results2  =  Activity.find_by_sql(sql_activities_i_assigned_with_tivit_requests).count
      puts " number of my other requests "+results2.to_s
     
      return results1+results2

  

  end
  
  
  
  def get_incoming_tivits (currentuser)
  
# Returns tivits i own and required my response or in play (awaiting the assiger to response with my proposal).
   #results = self.tivits.joins(:tivit_user_statuses).where("activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id
    #         AND ((NOT tivit_user_statuses.status_id = 'Done') AND (NOT tivit_user_statuses.status_id = 'OnIt' )) ",currentuser.id)
             
   results = self.tivits.joins(:tivit_user_statuses).where("activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id
             AND     (tivit_user_statuses.status_id = 'New' OR tivit_user_statuses.status_id = 'Reviewed')",currentuser.id)
             
             

    return results
  end


  
  def get_all_my_open_tivits (user)
    self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done'
AND activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id",user.get_id)
    
  end
  
  
  def get_need_attention_tivits (currentuser)
  
   #puts " current user = "+ currentuser.id.to_s
# Returns tivits i own and required my response or in play (awaiting the assiger to response with my proposal).
   results1 = self.tivits.joins(:tivit_user_statuses).where("activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id
AND ((NOT tivit_user_statuses.status_id = 'Done') AND (NOT tivit_user_statuses.status_id = 'OnIt' )) ",currentuser.id)


# Returns tivits that belong to my activity but are not mine and need my attention or awaiting response from the assignee
  if(currentuser.id == self.owner_id)

results2 = self.tivits.joins(:tivit_user_statuses).where("not activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id
AND (tivit_user_statuses.status_id = 'Proposed' OR tivit_user_statuses.status_id = 'Declined')",currentuser.id)

results3 = self.tivits.joins(:tivit_user_statuses).where("activities.due > ? and tivit_user_statuses.user_id = activities.owner_id
AND NOT tivit_user_statuses.status_id = 'Done' ", Time.now)
  
  else
    results2 = []
    results3 = []
  end
 
results =(results1 + results2) | results3
#puts " restuns size "+results.size.to_s
return results
  end

  def get_my_tivits (user)
    #return self.tivits.where("owner_id = ? " ,user.id)
    puts "----------------->>>> in get_my tivits"
    my_done_tivits = self.tivits.joins(:tivit_user_statuses).where("tivit_user_statuses.status_id = 'Done'
      AND activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id ",user.get_id)

    my_open_tivits_no_due = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done'
      AND activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id AND activities.due IS NULL",user.get_id)
   
   
    my_open_tivits_due = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done'
      AND activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id AND activities.due IS NOT NULL",user.get_id).order(:due).reverse_order
   
   return my_open_tivits_due + my_open_tivits_no_due +  my_done_tivits
  end
  
  def get_team_tivits (user)
    
    puts "----------------->>>> in team_my tivits"
    team_done_tivits = self.tivits.joins(:tivit_user_statuses).where("tivit_user_statuses.status_id = 'Done'
      AND NOT activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id ",user.get_id)

    team_open_activities = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done'
      AND NOT activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id",user.get_id).order(:due).reverse_order
      
      
  # puts "my_open_activities = "+my_open_activities.size.to_s
  # puts "my_done_activities = "+my_done_activities.size.to_send
    return team_open_activities + team_done_tivits
  end

  def update_user_tivit_status_new(user)
  tivit_status = create_status_new(user)
  #puts "creating a task with status new"
  end
  
  
# After the user viewed the tivit for the first time, make sure status changes from New to Review
  def update_status_after_show(user)
 # puts "------------------------------------------------------------"
 # puts "AFTER show attempting to change status for activity "+self.id.to_s+ " "+self.activity_name
 #puts "------------------------------------------------------------"
    status = self.get_user_status(user)
    if(status == "New")
       change_status(user,"Reviewed","")
       puts "chaging status from new to Review"
    end
# puts "Changing the date of last review og the comments"
#updating the date/time a user reviewed this activity/tivit
    tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
    tivit_user_status.update_last_reviewed
  
    if(self.tivits !=nil )
        self.tivits.each do |tivit|
          tivit.update_status_after_show(user)
        end
    end
  end
 
 
 def update_tivit_user_status_reminded(user,comment)
  change_status(user,"Reminded",comment)
 end
 
 def update_tivit_user_status_onit(user,comment)
  change_status(user,"OnIt",comment)
  self.change_status_to_in_progress if self.isDone?
  
 end
 
 def update_tivit_user_status_reviewed(user,comment)
  change_user_status(user,"Reviewed",comment,nil,Time.now().utc,nil)
 
 end
 
 def update_tivit_user_status_decline(user,comment)
  change_status(user,"Declined",comment)
  self.change_status_to_in_progress if self.isDone?
  
 end
 
 def update_tivit_user_status_i_am_done(user,comment)
  
  change_status(user,"Done",comment)
 # self.change_status_to_done
 # puts "gggggggggggggggggggggggggggggggggggggggggggggggggg"
 # puts self.inspect
 # puts "gggggggggggggggggggggggggggggggggggggggggggggggggg"
 end
 
 def update_tivit_user_propose_date(user,comment,date)
  change_user_status(user,"Proposed",comment,date,Time.now().utc,nil)
  self.change_status_to_in_progress if self.isDone?
 end
 
 
 def update_tivit_status_reassiged(user,comment,assined_user)
  change_user_status(user,"Reassigned",comment,nil,Time.now().utc,assined_user)
     
 end
      
#returns the status of a user with respect to this activity

  def get_user_status(user)
   tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
   if(tivit_user_status == nil)
   tivit_user_status = create_status_new(user)
   end
  
    return tivit_user_status.status_id
  end
 
 
 def get_owner_status
    tivit_user_status = self.tivit_user_statuses.find_by_user_id(self.get_owner)
    if(tivit_user_status == nil)
      tivit_user_status = create_status_new(self.get_owner)
    end
    return tivit_user_status.status_id
  end
  
#returns the comments associated with a specific user and this activity
 def get_user_status_comment(user)
   tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
   if(tivit_user_status == nil)
   tivit_user_status = create_status_new(user)
   end
    return tivit_user_status.comment
  end
  
  
# return the proposed date of the owner
 def get_owner_proposed_date
  tivit_user_status = self.tivit_user_statuses.find_by_user_id(self.owner_id)
   return tivit_user_status.proposed_date if (tivit_user_status != nil && tivit_user_status.last_reviewed != nil)
   return nil
 end
 
 
 def get_owner_last_status_change
  return self.tivit_user_statuses.find_by_user_id(self.owner_id).last_status_change
 end
 
 def get_owner_last_review_date
  return self.tivit_user_statuses.find_by_user_id(self.owner_id).last_reviewed
 end

# Get's the number of unread comments (do not include new comments from user)
 
 def get_number_of_unread_comments(user)
#get date of last unread
#puts "tivit: "+self.activity_name+ " id = "+self.id.to_s
#puts "checking status for user "+user.get_name

     tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
     if (tivit_user_status != nil && tivit_user_status.last_reviewed != nil)
   # puts "tivit_user_status.last_reviewed = " + tivit_user_status.last_reviewed.inspect
     size = self.tivitcomments.where("created_at > ? AND NOT user_id = ?",tivit_user_status.last_reviewed,user.id).count
     #size = 1
     #if(size > 0)
     #     puts "number of unread comment "+size.to_s
     #end
       return size
     else
     #puts "tivit_user_status.last_reviewed = nill"
       return self.get_number_of_comments
     end
  end
 
  
  def get_number_of_comments
     if(self.tivitcomments == nil)
       return 0
     else
       return self.tivitcomments.size
     end
  end
  
 def clean_user_invitees
 #clean users accept the task owber
  owner = self.get_owner
  self.users = [owner]

  end

 def get_due_date
    return self.due
 end
  
  def get_local_due_date_str
 #return due date. If nill return empty string
    if(self.due == nil)
      return ""
    else
      return self.due.localtime.strftime("%m-%d-%Y");
    end
  end
   
 def get_owner
 #adding the user to the existing users on the task
return User.find_by_id(self.owner_id)
 end
 
 def get_owner_id
  return self.owner_id
 end


 def isOwner?(user)
# checks if user if the owner of this activity / tivit
   return (user == self.get_owner)
 end
 
 
 
 def isParentOwner?(user)
# checks if user is the owner of the activity this tivit belogs to, assumming it is an activity

   return false if (user == nil || self.get_parent == nil)
   return self.get_parent.isOwner?(user)
 end
 
 
 def wasInvitedByUser?(user)
   
   return false if (user == nil)
   
   if(self.invited_by != nil && self.invited_by == user.get_id)
     return true
   end
   
   if (user.get_id == self.get_parent.owner_id)
     return true
   end
   return false
 end
 
 def get_invited_by
 #returned activity owner if invited by is nill
    if(self.invited_by == nil)
      return self.get_parent.get_owner
    else
      return User.find_by_id(self.invited_by)
    end
 end

 
 def get_number_of_tivits
#returns number of tivits
  if(self.tivits == nil || self.tivits.size == 0)
    return 0
  else
    return self.tivits.size
 end
 end
  

  
  def get_number_of_completed_tivits
   return 0 if (self.tivits == nil || self.tivits.size == 0)
   count = 0
   self.tivits.each do |tivit|
status = tivit.get_user_status(tivit.get_owner)
if (status == "Done")
count = count+1
end
end
   return count
  end
  
  def get_total_tivits
   return 0 if(self.tivits == nil || self.tivits.size == 0)
# return TivitUserStatus.where(:activity_id => self.id.inspect, ).count
return self.tivits.size
  
  end
  
  def get_activity_tivit_status
#returns a string of how many tivits have been completed
# need to remove business logic from model
if(self.tivits == nil || self.tivits.size == 0)
return "no tivits"
else
count = 0
# puts "get_activity_tivit_status = " +self.tivits.size.inspect

self.tivits.each do |tivit|
status = tivit.get_user_status(tivit.get_owner)
#puts "status = "+ status
if (status == "Done")
count = count+1
end
end
end
return count.inspect + "/" + self.tivits.size.inspect+" tivits have been completed"

  end

# Checking to see if the task was previously closed. This will be used before the email is sent out below

  def update_activity_status (summary)
   puts "Changng status from " +self.status+" to = " +status
   
   #if(self.status == status)
     #return
   #else
    if(status == "Completed")
     change_status_to_completed (summary)
     else
     change_status_to_in_progress
     end
   #end

  end

  def change_status_to_completed (summary)
   puts "change_status_to_completed"
self.completed_at = Time.now()
   self.status = "Completed"
   self.summary = summary if(summary != nil)
   if(!self.save)
   return false
   end
   if(self.tivits != nil || self.tivits.size > 0)
self.tivits.each do |tivit|
if(!tivit.change_status_to_completed (nil))
return false
end
end
end
return true
  end

  def change_status_to_in_progress
    puts "change_status_to_in_progress"
self.status = "in-progress"
self.save
   if(self.tivits != nil || self.tivits.size > 0)
self.tivits.each do |tivit|
tivit.change_status_to_in_progress
end
end
  end
  
  def change_status_to_done
    puts "change_status_to_Done"
    self.status = "Done"
    self.save
  end
  
  def isDone?
     return self.status == "Done"
  end
  
  # [Yaniv] Return status window for tivit or activity. This function is used in many places in the UI to determine 
  # what format of calendar icon to show and tivit & activity status lines as it varies depending on the due date window
  # relative to now
  def get_due_window_from_now ()
    if self.due == nil
      return "none"
    elsif self.due.localtime.end_of_day < Time.now.end_of_day
      return "overdue"
    elsif self.due.localtime.end_of_day == (Time.now.end_of_day) 
      return "today"
    elsif self.due.localtime.end_of_day > (Time.now.end_of_day) && self.due.localtime.end_of_day == (Time.now + 1.day).end_of_day
      return "tomorrow"
    elsif self.due > (Time.now) && self.due < (Time.now + 7.day)
      return "withinaweek"
    else
      return "morethanaweek"
    end
  end
  
private

 def create_status_new(user)
  return create_status(user,"New")
 end
 
 
 def create_status(user, status)
  tivit_status = user.tivit_user_statuses.new()
  if(false)
    puts " ---------------- Changing status ------------------------- "
    if(tivit_status.status_id == nil)
      puts " nil -->>> " + status
    else
      puts tivit_status.status_id + "-->>> " + status
    end
  end
 
    tivit_status.status_id = status
    tivit_status.activity_id = self.id
    tivit_status.save()
    return tivit_status
    
 end
 
 
 def change_user_status(user, status,comment, proposed_date, last_reviewed, assigned_to)
 #puts "changing status for "+user.get_name+" to "+status
   tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
   if(tivit_user_status == nil)
   tivit_user_status = create_status(user,status)
   end
  
  if(proposed_date != nil)
  tivit_user_status.proposed_date = proposed_date
  end
 
if(last_reviewed != nil)
  tivit_user_status.last_reviewed = last_reviewed
  end
 
  if(assigned_to != nil)
    puts "updtating assign to: = "+assigned_to.id.to_s
    tivit_user_status.assigned_to = assigned_to.id
  end

   tivit_user_status.status_id = status
   #tivit_user_status.comment = clean_comment(comment)
   tivit_user_status.last_status_change = Time.now.utc
   tivit_user_status.save()
    return tivit_user_status.status_id
 end
 
  
 def change_status(user, status,comment)
   change_user_status(user, status,comment, nil,nil,nil)
 end
  
  



end