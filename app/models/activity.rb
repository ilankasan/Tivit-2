class Activity < ActiveRecord::Base
  
  attr_accessible :name, :description,  :status_id, :due,:invited_by,:owner_id, :users, :completed_at, :summary,:activity_type, :parent_id,:activity_name, :documents, :parent
  validates :name, :presence => true
# each Tivit has many participants
  has_and_belongs_to_many :users
  has_and_belongs_to_many :documents
  
  has_one :parent, :class_name => "Activity", :primary_key => "parent_id", :foreign_key => "id"
  
  has_one :owner,  :class_name => "User", :primary_key => "owner_id", :foreign_key => "id"
  
  

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
 # validates_inclusion_of :status, :in => %w(in-progress Completed),
  #  :message => "%{value} is not a valid status"
  #ilan fix this with id after removing the olf field


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


  def get_number_of_completed_tasks( user)
     size = self.tivits.where(:owner_id=>user.get_id, :status_id =>TivitStatus.get_completed_id).count
     puts "get_number_of_completed_tasks => "+size.to_s
     return size
  end

def get_id
  return self.id
end

#return a unique array of all users who commented on this tivit
   def get_all_tivit_commenters_excluding_user (user)
# Ilan: This code can be improved by using a distinct SQL command
#return array of users excluding user
     users = User.joins(:tivitcomments).where("tivitcomments.activity_id = ? AND users.id = tivitcomments.user_id AND NOT tivitcomments.user_id = ? ",self.id, user.get_id)
  
     users = users.uniq
     return users
   end
   
 def get_completed_tivits

            
     array= self.tivits.where(:status_id=>TivitStatus.get_completed_id)
            
    return array
 
 end
  
  
  def get_all_my_tivits (user)
    self.tivits.where(:owner_id => user.get_id)
  end
  
  
  def get_on_deck_tivits (user)
    #puts "new  --------------->>>>>>>>>>>>>>>>> On deck filter! ---->>>  "+self.name+ "  "+self.id.to_s
    
     sql = "SELECT DISTINCT tivits.* FROM activities as tivits, tivitcomments as mycomments , tivitcomments as othercomments, tivit_user_statuses
            WHERE tivits.activity_type            = 'tivit'
              AND tivits.parent_id                = "+self.id.to_s+"
              AND mycomments.activity_id          = tivits.id
              AND mycomments.user_id              = "+user.get_id.to_s+"
              AND tivit_user_statuses.user_id     = "+user.get_id.to_s+"
              AND tivit_user_statuses.activity_id = tivits.id
              AND othercomments.activity_id       = tivits.id
              AND othercomments.created_at        > tivit_user_statuses.last_reviewed
              AND NOT othercomments.user_id       = "+user.get_id.to_s+"
              ORDER BY tivits.due"
         
  #         puts "-------------<<<<<<<<<<<<<<-------------------------------------------------"
     
    tivits_i_commented_with_new_comments = Activity.find_by_sql([sql])
    
 #   puts "tivits with comments "+tivits_i_commented_with_new_comments.size.to_s
   
    if(self.owner_id == user.get_id)
#My activity - show: 
#All open tivits and thoses with comments
#Only when they are in my activity and have a new status or comment since last view
# added remove tivits i declined

    
      my_open_tivits = self.tivits.joins(:tivit_user_statuses).where(
                                    "   NOT activities.status_id          = ?
                                    AND NOT tivit_user_statuses.status_id = 'Declined'
                                    AND tivit_user_statuses.user_id       = activities.owner_id 
                                    AND activities.owner_id               = ? ",TivitStatus.get_completed_id,user.get_id).order(:due).reverse_order
                                    
     
      other_open_tivits = self.tivits.joins(:tivit_user_statuses).where(
                                   #"NOT tivit_user_statuses.status_id = TivitStatus.get_completed_id
                                    "NOT activities.status_id       = ?
                                    AND tivit_user_statuses.user_id = activities.owner_id 
                                    AND NOT activities.owner_id     = ? ",TivitStatus.get_completed_id,user.get_id).order(:due).reverse_order
         
      

      return (my_open_tivits + other_open_tivits + tivits_i_commented_with_new_comments).uniq
   
    else
  
# Not my activity - i am not the owner
# my open tivits
# tivits i commented and have a comment
      #puts "----------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> user is NOT the owner of activity"
      
# Get only my open tivits and tivits i am the invitee (asignee)

      my_open_tivits = self.tivits.joins(:tivit_user_statuses).where(
                 "NOT activities.status_id              = ?
                  AND NOT tivit_user_statuses.status_id = ?
                  AND activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id",TivitStatus.get_completed_id,TivitStatus.get_declined_id, user.get_id).order(:due).reverse_order
       
      #puts "My open tivit "+my_open_tivits.size.to_s
     
      old_open_tivits_im_asignee = self.tivits.joins(:tivit_user_statuses).where(
                    "NOT activities.status_id        = ?
                     AND activities.invited_by       = ? 
                     AND tivit_user_statuses.user_id = activities.owner_id",TivitStatus.get_completed_id,user.get_id)
      
 #(recently ilan kasan)
      open_tivits_im_asignee = self.tivits.where(
                    "NOT activities.status_id = ? AND activities.invited_by = ?",TivitStatus.get_completed_id,user.get_id)
                 
      return (my_open_tivits+open_tivits_im_asignee+tivits_i_commented_with_new_comments).uniq
    end
  end
  
  def get_requests_tivits(currentuser)
    my_tivits    = self.tivits.joins(:tivit_user_statuses).where(
      "      tivit_user_statuses.user_id     = activities.owner_id 
       AND     activities.owner_id           = ?
       AND NOT activities.status_id          = ?
       AND NOT activities.invited_by         = ? 
       AND  (tivit_user_statuses.status_id = ? OR tivit_user_statuses.status_id = ?)",
       currentuser.id,TivitStatus.get_completed_id,currentuser.id,TivitStatus.get_new_id,TivitStatus.get_reviewed_id)
       
 #  puts " number of my new requests "+my_tivits.length.to_s
             
   other_tivits = self.tivits.joins(:tivit_user_statuses).where("tivit_user_statuses.user_id = activities.owner_id 
       AND   NOT activities.owner_id           = ? 
       AND activities.invited_by               = ?
       AND   NOT activities.status_id          = ?
        
       AND (tivit_user_statuses.status_id = ? OR tivit_user_statuses.status_id = ?)",
        currentuser.id,currentuser.id,TivitStatus.get_completed_id,TivitStatus.get_proposed_id,TivitStatus.get_declined_id)
       
   # puts " number of  requests new  new requests"+other_tivits.length.to_s          
   
    return my_tivits + other_tivits
  end
  
  
  
  def self.get_num_of_requests_tivits(currentuser)
  #  puts "______>>>>>  get_num_of_requests_tivits   <<<<_____"
    
    current_user_id = currentuser.get_id.to_s
    sql_activities_with_my_tivits = "SELECT DISTINCT tivits.id FROM activities, activities as tivits, tivit_user_statuses
                                                         
                   WHERE NOT activities.status_id      = "+TivitStatus.get_completed_id.to_s+"  
                   AND  activities.activity_type       = 'activity' 
                   AND  tivits.owner_id                = "+current_user_id+"
                   AND  NOT tivits.invited_by          = "+current_user_id+"   
                   AND  tivits.parent_id               = activities.id  
                   AND  tivits.owner_id                = tivit_user_statuses.user_id 
                   AND  tivits.id                      = tivit_user_statuses.activity_id 
                   AND  (tivit_user_statuses.status_id = "+TivitStatus.get_new_id.to_s+" OR tivit_user_statuses.status_id = "+TivitStatus.get_reviewed_id.to_s+")
                   AND  NOT tivits.status_id               = "+TivitStatus.get_completed_id.to_s+"
                   ORDER BY activities.due"
    
     results1  =  Activity.find_by_sql(sql_activities_with_my_tivits).count
    # puts " number of my new requests "+results1.to_s
             
   
      
     sql_activities_i_assigned_with_tivit_requests = "SELECT DISTINCT tivits.id FROM activities, activities as tivits, tivit_user_statuses 
                   WHERE NOT activities.status_id        = "+TivitStatus.get_completed_id.to_s+"  
                   AND     activities.activity_type      = 'activity'
                   AND NOT tivits.owner_id               = "+current_user_id+"
                   AND     tivits.invited_by             = "+current_user_id+"   
                   AND     tivits.parent_id              = activities.id  
                   AND     tivits.owner_id               = tivit_user_statuses.user_id 
                   AND     tivits.id                     = tivit_user_statuses.activity_id 
                   AND  ( tivit_user_statuses.status_id  = "+TivitStatus.get_declined_id.to_s+" OR tivit_user_statuses.status_id  = "+TivitStatus.get_proposed_id.to_s+" )
                   AND  NOT tivits.status_id                = "+TivitStatus.get_completed_id.to_s+"
                 
                   ORDER BY activities.due"
                 
      results2  =  Activity.find_by_sql(sql_activities_i_assigned_with_tivit_requests).count
     
      return results1+results2
  end
  
  

 def get_unresponded_tivits (user)
#1. show MY tivits that I have not read or not responded to
#2. show OTHERS tivits that have not been read or not responded to in activities I own
#3. show OTHERS tivits that have not been read or not responded that i invited someone
 #   puts "---->>>>>>>>>>>>>> get_unresponded_tivits"
    if(self.get_owner == user)
#User is the owner of the activity
     #   puts "---->>>>>>>>>>>>>> get_unresponded_tivits"
        unresponded_tivits = self.tivits.joins(:tivit_user_statuses).where("(tivit_user_statuses.status_id = ? OR tivit_user_statuses.status_id = ?)
            AND tivit_user_statuses.user_id = activities.owner_id",TivitStatus.get_new_id,TivitStatus.get_reviewed_id)
    else
#User is NOT the owner of the activity
        unresponded_tivits = self.tivits.joins(:tivit_user_statuses).where("(tivit_user_statuses.status_id = ? OR tivit_user_statuses.status_id = ?)
            AND (activities.owner_id = ? OR activities.invited_by = ? ) AND tivit_user_statuses.user_id = activities.owner_id",TivitStatus.get_new_id,TivitStatus.get_reviewed_id,user.get_id, user.get_id)    
    end
    puts "unresponded_tivits = "+ unresponded_tivits.size.to_s
    return unresponded_tivits 
 end
  
  def get_all_my_open_tivits (user)
    
    tivit_with_due = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = ?
AND activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id AND activities.due IS NOT NULL",TivitStatus.get_completed_id,user.get_id).order(:due).reverse_order

    tivit_due_null = self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = ?
AND activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id AND activities.due IS NULL",TivitStatus.get_completed_id,user.get_id)

  return (tivit_with_due + tivit_due_null)
    
  end
  
  def get_open_tivits (user) 
 #  puts "------------->>>>>>>>>>>>>>>>   in get_open_tivits"
    #self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = ?
     #                AND tivit_user_statuses.user_id = activities.owner_id",TivitStatus.get_completed_id).order(:due).reverse_order
   # time = Time.now()
      r =  self.tivits.where("(status_id = ? ) OR (status_id = ? AND NOT owner_id = ?)",TivitStatus.get_in_progress_id,TivitStatus.not_started_id, user.get_id).order(:due).reverse_order
     #                AND tivit_user_statuses.user_id = activities.owner_id",TivitStatus.get_completed_id).order(:due).reverse_order
      return r
    
  end
 
  
  

  def get_my_tivits (user)
     #puts "--------^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--------->>>> in get_my tivits"
    my_done_tivits = self.tivits.where(:owner_id => user.get_id ,:status_id => [TivitStatus.get_completed_id])
   #puts "--------^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--------->>>> in get_my tivits"
    my_open_tivits_no_due = self.tivits.where(:owner_id => user.get_id ,:status_id => [TivitStatus.get_in_progress_id, TivitStatus.get_closed_id ],:due => nil)
    #puts "--------^^^^^^^ my_open_tivits_no_due ^^^^^^^^^^^^^^^^^^^^^^^^^^^^--------->>>> "+my_open_tivits_no_due.count.to_s
    my_open_tivits_due = self.tivits.where("owner_id = ? AND NOT status_id = ? AND due IS NOT NULL",user.get_id,TivitStatus.get_completed_id).order(:due).reverse_order
   
 #puts "--------^^^^^^^ my_open_tivits_due ^^^^^^^^^^^^^^^^^^^^^^^^^^^^--------->>>> "+my_open_tivits_due.count.to_s
     
    return my_open_tivits_due + my_open_tivits_no_due +  my_done_tivits
  end
  
  
  def get_my_open_tivits (user)
 #    puts "--------^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--------->>>> in get_my_open_tivits"
    r = self.tivits.where(:owner_id => user.get_id ,:status_id => [TivitStatus.get_in_progress_id])
    return r
  end
  
  
# get tasks user has not responded yet
  def get_my_new_tasks (user)
    r = self.tivits.where(:activity_type => 'tivit', :owner_id => user.get_id, :status_id =>TivitStatus.not_started_id )
    puts "--------^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--------->>>> in get_my_new_tasks "+r.size.to_s
    return r
  end
  
  #[Yaniv REQUEST] Ilan, please update this fucntion to return only tasks that are unassigned. That should include tasks that users declided and 
  # current have no owner
  def get_unassigned_tasks
    r =   self.tivits.where(:status_id => TivitStatus.get_unassigned_id).order(:due)
    return r
  end
  
  def get_num_unassigned_tasks 
    return self.tivits.where(:status_id => TivitStatus.get_unassigned_id).order(:due).count
  end
  
  
  def get_my_open_tasks_i_agreed_to_help_with (user)
  # puts "^^^^^^^^^^^^^^^--------->>>> get_my_open_tivits_i_agreed_to_help_with"
        r =   self.tivits.joins(:tivit_user_statuses).where(
                          "activities.owner_id       = ?
                  AND  activities.status_id          = ?
                  AND  activities.owner_id           = tivit_user_statuses.user_id 
                  AND  tivit_user_statuses.status_id = ?", 
                  user.get_id, TivitStatus.get_in_progress_id,TivitStatus.get_onit_id).order(:due)
      return r
  end
 
 def get_my_completed_tasks (user, remove_task_id)
  puts "^^^^^^^^^^^^^^^--------->>>> get_my_completed_tasks"
  
  last_reviewed =  self.get_last_reviewed (user)
     #self.created_at > tivit_user_status.last_reviewed
     
   #  t =  self.tivits.where("NOT activities.id = ? AND activities.owner_id = ? AND  activities.status_id = ? AND activities.updated_at < ?",remove_task_id,user.get_id, TivitStatus.get_completed_id, last_reviewed).order(:completed_at)
     t =  self.tivits.where("activities.owner_id = ? AND  activities.status_id = ? AND activities.updated_at < ?",user.get_id, TivitStatus.get_completed_id, last_reviewed).order(:completed_at)
   
     puts "^^^^^^^^^^^^^^^--------->>>> get_my_completed_tasks = "+t.size.to_s
  
     return t
  
 end
 def is_recently_completed_adp? (user)
    if(self.completed_at > self.get_last_reviewed(user))
      return true
    else
      return false
    end
    
 end
 
 def is_recently_completed_tab? (user)
   
    return false if (self.completed_at == nil)
    return true  if (LastReviewed.get_last_updated_completed_tasks(user) == nil)  
    if (self.completed_at > LastReviewed.get_last_updated_completed_tasks(user))
      return true
    else
      return false
    end
    
 end
 
 
 def get_num_of_completed_tasks (user)
     return self.tivits.where(:owner_id => user.get_id ,:status_id => TivitStatus.get_completed_id).count
 end
 
 def get_team_new_tasks (user)
    
    return self.tivits.where(
                  "NOT activities.owner_id     = ?
                  AND  activities.status_id    = ?", 
                  user.get_id, TivitStatus.not_started_id).order(:created_at)
 end
  
  
 def get_team_open_tasks_they_agreed_to_help_with (user)
   #  return self.tivits.where(" NOT owner_id = ? AND status_id = ?",user.get_id, TivitStatus.get_in_progress_id).order(:due)
   r =   self.tivits.joins(:tivit_user_statuses).where(
                          "NOT activities.owner_id       = ?
                  AND  activities.status_id          = ?
                  AND  activities.owner_id           = tivit_user_statuses.user_id 
                  AND  tivit_user_statuses.status_id = ?", 
                  user.get_id, TivitStatus.get_in_progress_id,TivitStatus.get_onit_id).order(:due)
  
      return r
 end
 def get_last_reviewed (user)
   tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.get_id)
   if(tivit_user_status == nil)
     puts "user last status is nil !!!!!"
     return 1
   else
  #    puts "last reviewed for activity  "+self.id.to_s+ " for user "+user.get_id.to_s+" is "+tivit_user_status.last_reviewed.to_s+" validating user "+tivit_user_status.user_id.to_s
      return tivit_user_status.last_reviewed
   end
 end
  def get_recently_team_completed_tasks (user, task_id)
  #  puts "get_recently_team_completed_tasks"
     last_reviewed =  self.get_last_reviewed (user)
     #self.created_at > tivit_user_status.last_reviewed
     results = self.tivits.where("NOT activities.owner_id = ? AND  activities.status_id = ? AND activities.updated_at > ?",user.get_id, TivitStatus.get_completed_id, last_reviewed).order(:completed_at)     
     task    = self.tivits.where("NOT activities.owner_id = ? AND  activities.status_id = ? AND activities.id = ?",user.get_id, TivitStatus.get_completed_id, task_id)
  #   puts "completed task = "+task.inspect+ " for od "+task_id.to_s 
     return (task+results).uniq       
  end
  
  def get_my_recently_completed_tasks(user, task_id)
  # puts "get_my_recently_completed_tasks"
     last_reviewed =  self.get_last_reviewed (user)
     
     results =  self.tivits.where("activities.owner_id = ? AND  activities.status_id = ? AND activities.updated_at > ?",user.get_id, TivitStatus.get_completed_id, last_reviewed).order(:completed_at)
     task    = self.tivits.where("activities.owner_id = ? AND  activities.status_id = ? AND activities.id = ?",user.get_id, TivitStatus.get_completed_id, task_id)
     t =  (task+results).uniq
      puts "get_my_recently_completed_tasks = "+t.size.to_s
     return t      
  end
  
  
  def get_team_completed_tasks (user, remove_task_id)
    
     last_reviewed =  self.get_last_reviewed (user)
   
     ##r =  self.tivits.where("NOT activities.id = ? AND NOT owner_id = ? AND  status_id = ? AND  activities.updated_at < ?", remove_task_id, user.get_id, TivitStatus.get_completed_id, last_reviewed).order(:completed_at).reverse_order
     #r =  self.tivits.where("NOT owner_id = ? AND  status_id = ? AND  activities.updated_at < ?", user.get_id, TivitStatus.get_completed_id, last_reviewed).order(:completed_at).reverse_order
     
     r =  Activity.where("parent_id = ? AND NOT owner_id = ? AND  status_id = ? AND  activities.updated_at < ? AND NOT activities.id = ? ", self.id,user.get_id, TivitStatus.get_completed_id, last_reviewed,remove_task_id).order(:completed_at).reverse_order
     
           
     #return Activity.where("status_id = ? AND activity_type = 'tivit' AND (owner_id = ? OR invited_by = ?)",TivitStatus.get_completed_id, user.get_id, user.get_id ).order(:completed_at).paginate(:page => params[:page], :per_page => 15)
     
     
     puts "----->>>>>>>>>>>>>>>  get_team_completed_tasks "+r.size.to_s
     
     return r
  end
 
 
  def delete_this_get_num_of_team_completed_tasks (user)
     return self.tivits.where("NOT owner_id = ? AND  status_id = ?",user.get_id, TivitStatus.get_completed_id).count
  end
  
  
  
  
  def get_team_tivits (user)
    
   # puts "----------------->>>> in team_my tivits"
   #time = Time.now()
    team_done_tivits = self.tivits.where("NOT owner_id = ? AND (status_id = ? )",user.get_id, TivitStatus.get_completed_id)
    
    #puts "--------^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--------->>>> team_done_tivits "+team_done_tivits.count.to_s
    team_open_tivits_no_due  = self.tivits.where("NOT owner_id = ? AND NOT (status_id = ?) AND due IS NULL",user.get_id, TivitStatus.get_completed_id)
    
    #puts "--------^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--------->>>> team_open_tivits_no_due "+team_open_tivits_no_due.count.to_s
    team_open_tivits_due  = self.tivits.where("NOT owner_id = ? AND NOT (status_id = ?) AND due IS NOT NULL",user.get_id,TivitStatus.get_completed_id)
     
  # puts "my_open_activities = "+my_open_activities.size.to_s
 #  puts "my_done_activities = "+my_done_activities.size.to_send
   #   puts "$$$$  <<<--- get_team_tivits "+(Time.now()-time).to_s
      
    return (team_open_tivits_due + team_open_tivits_no_due + team_done_tivits)
  end

  def update_user_tivit_status_new(user)
  tivit_status = create_status_new(user)
  #puts "creating a task with status new"
  end
  
  
# After the user viewed the tivit for the first time, make sure status changes from New to Review
  def update_status_after_show(user)
 # puts "------------------------------------------------------------"
  #puts "AFTER show attempting to change status for activity "+self.id.to_s+ " "+self.name
 #puts "------------------------------------------------------------"
    status = self.get_user_status(user)
    if(status == TivitStatus.get_new_id)
       change_status(user,TivitStatus.get_reviewed_id,"")
      # puts "------>>>>> chaging status from new to Review"
    end
# puts "Changing the date of last review og the comments"
#updating the date/time a user reviewed this activity/tivit
    tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
    tivit_user_status.update_last_reviewed
# ilan revisit this code
    if(self.tivits !=nil && false)
        self.tivits.each do |tivit|
          tivit.update_status_after_show(user)
        end
    end
  end
 
 
 def update_last_reviewed(user)
 # puts "------------------------------------------------------------"
 # puts "AFTER show attempting to change status for activity "+self.id.to_s+ " "+self.activity_name
 #puts "------------------------------------------------------------"
    status = self.get_user_status(user)
    if(status == TivitStatus.get_new_id)
       change_status(user,TivitStatus.get_reviewed_id,"")
    #   puts "------>>>>> chaging status from new to Review"
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
  change_status(user,TivitStatus.get_reminded_id,comment)
 end
 
 def update_tivit_user_status_onit(user,comment)
  # puts "update_tivit_user_status_onit   <<<<_________________ is done? "+self.isDone?
  change_status(user,TivitStatus.get_onit_id,comment)
#Ilan: not sure why we need this lie below
  self.change_status_id_to_in_progress 
  
 end
 
 def update_tivit_user_status_reviewed(user,comment)
  change_user_status(user,TivitStatus.get_reviewed_id,comment,nil,Time.now().utc,nil)
 
 end
 
 def update_tivit_user_status_decline(user,comment)
  change_status(user,TivitStatus.get_declined_id,comment)
#  self.change_status_to_in_progress if self.isCompleted?
   self.change_status_id_to_unassigned
   
 
  
 end
 
 def update_tivit_user_status_i_am_done(user,comment)
  
  change_status(user,TivitStatus.get_completed_id,comment)
 
 end
 
 def update_tivit_user_propose_date(user,comment,date)
  change_user_status(user,TivitStatus.get_proposed_id,comment,date,Time.now().utc,nil)
  self.change_status_id_to_in_progress if self.isCompleted?
 end
 
 def is_not_started?
   return self.status_id == TivitStatus.not_started_id
 end
 
 def is_completed?
  # puts "in is_completed, status = "+self.status_id.to_s+ " "+(self.status_id == TivitStatus.get_completed_id).to_s
   return self.status_id == TivitStatus.get_completed_id
 end
 
 def is_inprogress?
   return self.status_id == TivitStatus.get_in_progress_id
 end
 
 def is_unassigned?
   return self.status_id == TivitStatus.get_unassigned_id
 end
 
 def update_tivit_status_reassiged(user,comment,assined_user)
  change_user_status(user,TivitStatus.get_reassigned_id,comment,nil,Time.now().utc,assined_user)
  change_status_id_to_not_started 
 end
      
#returns the status of a user with respect to this activity

  def get_user_status(user)
   tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
   if(tivit_user_status == nil)
    tivit_user_status = create_status_new(user)
   end
    #puts "******666666666666666666666666***************************  "+tivit_user_status.status_id+"********************"
    
      
    return tivit_user_status.status_id
  end
 
 
 def get_owner_status
    #return "Done" if (self.isCompleted?) #ilan: rvisit this line
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
      time = Time.now()
      

     tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
     if (tivit_user_status != nil && tivit_user_status.last_reviewed != nil)
   # puts "tivit_user_status.last_reviewed = " + tivit_user_status.last_reviewed.inspect
       size = self.tivitcomments.where("created_at > ? AND NOT user_id = ?",tivit_user_status.last_reviewed,user.id).count
       return size
     else
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
     #puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   error no owner!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    return self.owner
    
 end
 
 def get_owner_name
 #adding the user to the existing users on the task
     user = User.find_by_id(self.owner_id)
    if user == nil
       "no owner error, call admin"
    else
       return user.name
    end
 end
 
 
 
 
 def get_owner_id
  # puts" in get opwner id  ---------> "+self.owner_id.to_s
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
   
   # Yaniv removed this as I'm not sure why it's needed...
   #if (user.get_id == self.get_parent.owner_id)
   #  return true
   #end
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
    if(self.tivits == nil || self.tivits.size == 0)
      return 0
    else
      return self.tivits.size
    end
 end
  

  
  def get_number_of_completed_tivits
   #puts "get_number_of_completed_tivits" 
   return 0 if (self.tivits == nil || self.tivits.size == 0)
   #puts "^^^^^^^^^^^^^^^^^^^^^  Activity = "+self.name
                                         
   count1 = self.tivits.where(:status_id=>[TivitStatus.get_completed_id]).count
  # puts "count 1 = "+count1.to_s
  # puts "count  = "+count.to_s
   return count1
 end
  
  def get_total_tivits
   return 0 if(self.tivits == nil || self.tivits.size == 0)
# return TivitUserStatus.where(:activity_id => self.id.inspect, ).count
return self.tivits.size
  
  end
  

# Checking to see if the task was previously closed. This will be used before the email is sent out below

  def change_status_to_completed (summary)
   #puts "------------->>>>. change_status_to_completed"
   
   self.completed_at = Time.now()
   self.status_id = TivitStatus.get_completed_id
   self.summary = summary if(summary != nil)
   
   if(self.tivits != nil || self.tivits.size > 0)
      self.tivits.each do |tivit|
# change status to closed only if current status in progress
        if(tivit.is_inprogress?)  
        #if(TivitStatus.is_in_progress_id?(tivit.status_id))
          tivit.change_status_id_to_closed
        end
     end
   end 
    return false if !self.save
     
    return true
  end
  
  def change_status_to_in_progress
   # puts "change_status_to_in_progress"
    
    change_status_id(TivitStatus.get_in_progress_id)
    if(self.tivits != nil || self.tivits.size > 0)
      self.tivits.each do |tivit|
        tivit.change_status_to_in_progress
      end
    end
  end
  
  
  def change_status_id(id)
    
    self.status_id = id
    self.save
  end
  def change_status_id_to_not_started
    
    change_status_id(TivitStatus.not_started_id) if !is_not_started? 
    
  end 
  
  def change_status_id_to_in_progress
    change_status_id(TivitStatus.get_in_progress_id)
    
  end
  def change_status_id_to_unassigned

    self.change_status_id(TivitStatus.get_unassigned_id)
    #puts "change_status_to_closed for tivit "+self.id.to_s
    
  end

  
  def change_status_id_to_closed
    #puts "change_status_to_closed for tivit "+self.id.to_s
    change_status_id(TivitStatus.get_closed_id)
    
  end
  
  def change_status_if_to_done
    puts "------>>>>>>>>>>>>>>>  change_status_to_Done --------------------------------------------"
    change_status_id(TivitStatus.get_completed_id)
  end
  
  def isCompleted?
     return TivitStatus.is_completed_id?(self.status_id)
     
  end
  
  
  def get_completed_user_name
  #  puts "in get_completed_user_name" 
     users_status = self.tivit_user_statuses.where(:status_id => TivitStatus.get_completed_id).order(:last_status_change)
    
     if (!users_status.nil? && !users_status[0].nil? )
       return users_status[0].get_user.get_name
     else  
       return "Error no user"
     end
        
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
  return create_status(user,TivitStatus.get_new_id)
 end
 
 
 
 def create_status(user, status)
  puts "^^^^^^^^^^^^^^   creating status " + status.to_s
  tivit_status = user.tivit_user_statuses.new()
  
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