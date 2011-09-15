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
  
  attr_accessible :name, :description, :status, :due,:invited_by,:owner_id, :users, :completed_at, :summary,:activity_type, :parent_id
# each Tivit has many participants 
  has_and_belongs_to_many :users

# every activity has many document asign to it
  has_many :activity_documents
  #has_many :documents, :through => :activity_documents 



# each tivit has many comments
  has_many :tivitcomments

# each tivit has many user status (show the specific status for each user)
  has_many :tivit_user_statuses
  
  #has_many :activities, :as => :imageable
  has_many :activities
  
  has_many :tivits, :class_name => "Activity",
    :foreign_key => "parent_id" 

  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :description, :length => { :maximum => 1024 }
  validates :owner_id, :presence => true
  validates :activity_type, :presence => true, :length => { :maximum => 140 }
  
  
  validates_inclusion_of :activity_type, :in => %w(activity tivit),
    :message => "%{value} is not a valid status"


  default_scope :order => 'activities.created_at DESC'

# Update status of theusers invites tot he activity
  def add_user_invitee(user)
 #adding the user to the existing users on the task
	self.users << user
	puts "&&&&&&&&&&&&&        updating user task status &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
# sending invitee an email invite
	owner = self.get_owner
# ilan: email invites shouldbein controllers not models
	UserMailer.new_tivit_email(user,owner,self).deliver
	
	self.update_user_tivit_status(user)

#ilan: not 100% we ned the save option
		
  end	

  def get_parent
  	
  	if(self.parent_id ==nil)
  			return nil
  	end
  	return Activity.find(self.parent_id)
  end



  def update_user_tivit_status(user)
 	puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
 	tivit_status = create_status_new(user)
 	puts "creating a task with status new"	
 		
  end
  
# After the user viewed the tivit for the virst time, make sure status changes from New to Review 
  def update_tivit_status_after_show(user)
 puts "------------------------------------------------------------"
 puts "attempting to change status" 	
 puts "------------------------------------------------------------" 	
 status = self.get_user_status(user) 	
 # ilan: the double comparison is temporary due to curroption of data
  	if(status == "New")
  		change_status(user,"Reviewed","")
  		puts "chaging status from new to Review" 	
  	end
  end
 
 def update_tivit_user_status_accept(user,comment)
 	change_status(user,"Accepted",comment)
 end
 
 def update_tivit_user_status_decline(user,comment)
 	change_status(user,"Declined",comment)

 end
 
 def update_tivit_user_status_i_am_done(user,comment)
 	change_status(user,"I Am Done",comment)
 end

#returns the status of a user with respect to this activity 

  def get_user_status(user)
  	tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
  	if(tivit_user_status == nil)
  		tivit_user_status = create_status_new(user) 		
  	end
  	
    return tivit_user_status.status_id
 	
  end
 
 
  
#returns the comment associated with a specific user and this activity 
 def get_user_status_comment(user)
  	tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
  	if(tivit_user_status == nil)
  		tivit_user_status = create_status_new(user)
 		
  	end
    return tivit_user_status.comment
 	
  end
  
###################################################
#      Get status givven one user per tivit       #
###################################################

#returns the status of a user with respect to this activity and this activity 
 # def get_user_status 	
 # 	return self.get_user_status(self.get_owner)
 # end
  
#returns the comment associated with a specific user and this activity 
 #def get_user_status_comment
#	return self.get_user_status_comment(self.get_owner)
# end
 def clean_user_invitees
 #clean users accept the task owber
 	owner = self.get_owner
 	self.users = [owner]

  end	


 def get_owner
 #adding the user to the existing users on the task
		return User.find_by_id(self.owner_id)
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
#returns the number of completed tivits 
	if(self.tivits == nil || self.tivits.size == 0)
		return "0"
	else
		count = 0
#		puts "get_activity_tivit_status = " +self.tivits.size.inspect

		self.tivits.each do |tivit|
			status = tivit.get_user_status(tivit.get_owner)
			puts "status = "+ status
			if (status == "I Am Done")
				count = count+1
			end
		end 
	end
	return count 
	
  end

  
  def get_activity_tivit_status
#returns a string of how many tivits have been completed
# need to remove business logic from model
#puts "get_activity_tivit_status"
#puts "_____________________________________________________"
	if(self.tivits == nil || self.tivits.size == 0)
		return "no tivits"
	else
		count = 0
#		puts "get_activity_tivit_status = " +self.tivits.size.inspect

		self.tivits.each do |tivit|
			status = tivit.get_user_status(tivit.get_owner)
			puts "status = "+ status
			if (status == "I Am Done")
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
  	puts "_____________________________________________________"
  	puts "_____________________________________________________"
  	puts "Changng status from " +self.status+" to = " +status
  	puts "_____________________________________________________"
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
  
private

 def create_status_new(user)	
 	return create_status(user,"New") 
 end 
 
 
 def create_status(user, status)
 	tivit_status = user.tivit_user_statuses.new()
 	puts " ----------------------------------------- "
 	puts " ----------------  Changing status ------------------------- "
 	if(tivit_status.status_id == nil)
 		puts " nil -->>> " + status
 	else
 		puts tivit_status.status_id + "-->>> " + status
 	end
 	puts " ----------------------------------------- "
 	
 	tivit_status.status_id = status
 	tivit_status.activity_id = self.id
 	tivit_status.save()
 	return tivit_status 
  
  end 
 
  
 def change_status(user, status,comment)
  	tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
  	if(tivit_user_status == nil)
  		tivit_user_status = create_status(user,status)
  	end
  	tivit_user_status.status_id = status
  	tivit_user_status.comment   = comment
  	tivit_user_status.save()
    return tivit_user_status.status_id
 end
   
end
