# == Schema Information
# Schema version: 20110309070830
#
# Table name: activities
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  description  :text
#  status       :string(255)
#  due          :datetime
#  owner_id     :integer(4)
#  who          :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  completed_at :datetime
#


class Activity < ActiveRecord::Base
  
  attr_accessible :name, :description, :status, :due,:invited_by,:owner_id, :users, :completed_at, :summary,:activity_type, :parent_id,:activity_name, :documents
# each Tivit has many participants 
  has_and_belongs_to_many :users
  has_and_belongs_to_many :documents





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
  def activity_name
  	return self.name
  end 
# Update status of the users invites to he activity
  
  def get_description
    return self.description
  end
  
  def add_user_invitee(user)
 #adding the user to the existing users on the task
	self.users << user
	# sending invitee an email invite
#	owner = self.get_owner
	
	self.update_user_tivit_status(user)

#ilan: not 100% we ned the save option
		
  end	

  def invitedByOwner?
  	return (self.invited_by == self.get_parent.get_owner.id) 
  end

  def isActivity?
  	return self.activity_type == "activity" 
  end
  
 # def get_invited_by
 # 	return if 
 # end
  def get_parent
  	
  	if(self.parent_id ==nil)
  			return nil
  	end
  	return Activity.find(self.parent_id)
  end

  def get_open_or_recently_done_tivits
	 self.tivits.joins(:tivit_user_statuses).where("tivit_user_statuses.user_id = activities.owner_id 
	 AND ((NOT tivit_user_statuses.status_id = 'Done') 
	 OR  ((tivit_user_statuses.status_id = 'Done' AND tivit_user_statuses.last_status_change > ?)))",Time.now.localtime-1.day) 	
  end
  
  
  def get_all_my_tivits (user)
    self.tivits.where(:owner_id => user.get_id)
  end
  
  #def get_all_my_open_tivits (user)
  #  self.tivits.where(:owner_id => user.get_id, )
  #end
  
  def get_all_my_open_tivits (user)
    #self.tivits.where(:owner_id => user.get_id)
    #not working
    self.tivits.joins(:tivit_user_statuses).where("NOT tivit_user_statuses.status_id = 'Done' 
      AND activities.owner_id = ? AND tivit_user_statuses.user_id = activities.owner_id",user.get_id)
     
   
   # self.tivits.joins(:tivit_user_statuses).where("tivit_user_statuses.user_id = activities.owner_id 
   #AND ((NOT tivit_user_statuses.status_id = 'Done') 
   #OR  ((tivit_user_statuses.status_id = 'Done' AND tivit_user_statuses.last_status_change > ?)))")  
    
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
  
	
	
	#results2 = self.tivits.joins(:tivit_user_statuses).where("tivit_user_statuses.user_id = activities.owner_id 
	#AND (tivit_user_statuses.status_id = 'Proposed' or tivit_user_statuses.status_id = 'Declined')")

	puts "total tivits "+tivits.size.to_s
										  
	results =(results1 + results2) | results3
	puts " restuns size "+results.size.to_s
	return results    	 	
  end


  def update_user_tivit_status_new(user)
 	tivit_status = create_status_new(user)
 	puts "creating a task with status new"			
  end
  
  
# After the user viewed the tivit for the first time, make sure status changes from New to Review 
  def update_status_after_show(user)
 #	puts "------------------------------------------------------------"
 #	puts "AFTER show attempting to change status for activity "+self.id.to_s+ " "+self.activity_name 	
 #puts "------------------------------------------------------------" 	
    status = self.get_user_status(user) 	
  	if(status == "New")
  		change_status(user,"Reviewed","")
  		puts "chaging status from new to Review" 	
  	end
#	puts "Changing the date of last review og the comments"
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
 	change_user_status(user,"Reviewed",comment,nil,Time.now().localtime,nil)
 	
 end
 
 def update_tivit_user_status_decline(user,comment)
 	change_status(user,"Declined",comment)
  self.change_status_to_in_progress if self.isDone?
  
 end
 
 def update_tivit_user_status_i_am_done(user,comment)
  
 	change_status(user,"Done",comment)
 	puts "gggggggggggggggggggggggggggggggggggggggggggggggggg"
 #	self.change_status_to_done
 #	puts "gggggggggggggggggggggggggggggggggggggggggggggggggg"
 #	puts self.inspect
 # puts "gggggggggggggggggggggggggggggggggggggggggggggggggg"
 # puts "gggggggggggggggggggggggggggggggggggggggggggggggggg"
  
 end
 
 def update_tivit_user_propose_date(user,comment,date)
   	
 	change_user_status(user,"Proposed",comment,date,Time.now().localtime,nil)
 	self.change_status_to_in_progress if self.isDone?
 	  
 end
 
 
 
 def update_tivit_status_reassiged(user,comment,assined_user)
  change_user_status(user,"Reassigned",comment,nil,Time.now().localtime,assined_user)
     
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
  	return  tivit_user_status.last_reviewed if (tivit_user_status != nil && tivit_user_status.last_reviewed != nil)
  	return "no proposed date"	
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
#puts "get_number_of_unread_comments"
#puts "tivit: "+self.activity_name+ " id = "+self.id.to_s
#puts "checking status for user "+user.get_name

 	tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
  	if (tivit_user_status != nil && tivit_user_status.last_reviewed != nil)
 # 		puts "tivit_user_status.last_reviewed = " + tivit_user_status.last_reviewed.inspect
  		size = self.tivitcomments.where("created_at > ? AND NOT user_id = ?",tivit_user_status.last_reviewed,user.id).count
  		#size = 1
  		if(size > 0)
        puts "________________________________________________________"
  		  puts "number of unread comment "+size.to_s
  		  puts "________________________________________________________"
  		end
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
 #return due date. If nill return empty string
 		if(self.due == nil)
 			return ""
 		else
			return self.due
		end
  end	

 def get_owner
 #adding the user to the existing users on the task
		return User.find_by_id(self.owner_id)
  end	

 def isOwner?(user)
   return (user.get_id == self.owner_id)    
 end
 
 def wasInvitedByUser?(user)
   #puts "in wasInvitedByUser"
   if (user == nil)
     return false
   end
   
   
   if(self.invited_by != nil && self.invited_by == user.get_id)
     return true
   end
   
   if (user.get_id == self.get_parent.owner_id)
     return true
   end
   return false
 end
 
 def get_invited_by
 #adding the user to the existing users on the task
		return User.find_by_id(self.invited_by)
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
#	return TivitUserStatus.where(:activity_id => self.id.inspect, ).count
	return self.tivits.size  		
  	
  end
  
  def get_activity_tivit_status
#returns a string of how many tivits have been completed
# need to remove business logic from model
	if(self.tivits == nil || self.tivits.size == 0)
		return "no tivits"
	else
		count = 0
#		puts "get_activity_tivit_status = " +self.tivits.size.inspect

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

#def set_completed
	#self.status = "Completed"
	#self.save
	#return
#end

# Checking to see if tthe task was previously closed. This will be used before the email is sent out below
	
  def update_activity_status (status)
  	puts "_____________________________________________________"
  	puts "Changng status from " +self.status+" to = " +status
  	puts "_____________________________________________________"
  	
  	if(self.status == status)
    	return
   else 
   		if(status == "Completed")
    		change_status_to_completed
    	else
    		change_status_to_in_progress
    	end
   end
	    	
  end

  def change_status_to_completed
  	puts "change_status_to_completed"
	  time = Time.now()
  	self.completed_at = time.localtime
  	self.status       = "Completed"
  	self.save 
  	if(self.tivits != nil || self.tivits.size > 0)
		self.tivits.each do |tivit|
			tivit.change_status_to_completed
		end
	end
  end
	  
  def change_status_to_in_progress
    puts "change_status_to_in_progress"
	  self.status       = "in-progress"
	  self.save
  	 if(self.tivits != nil || self.tivits.size > 0)
		  self.tivits.each do |tivit|
			   tivit.change_status_to_in_progress
		  end
	   end 
  end
  
  def change_status_to_done
    puts "change_status_to_Done"
    self.status       = "Done"
    self.save
  end 
  
  def isDone?
     return self.status == "Done"
  end 
  
private

 def create_status_new(user)	
 	return create_status(user,"New") 
 end 
 
 
 def create_status(user, status)
 	tivit_status = user.tivit_user_statuses.new()
 	puts " ----------------  Changing status ------------------------- "
 	if(tivit_status.status_id == nil)
 		puts " nil -->>> " + status
 	else
 		puts tivit_status.status_id + "-->>> " + status
 	end
 	
 	tivit_status.status_id = status
 	tivit_status.activity_id = self.id
 	tivit_status.save()
 	return tivit_status 
  
  end 
 
 
 def change_user_status(user, status,comment, proposed_date, last_reviewed, assigned_to)
 puts "changing status for "+user.get_name+" to "+status
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
  	tivit_user_status.comment   = comment
  	tivit_user_status.last_status_change = Time.now.localtime
  	tivit_user_status.save()
    return tivit_user_status.status_id
 end
 
  
 def change_status(user, status,comment)
  	change_user_status(user, status,comment, nil,nil,nil)
 end
   
end
