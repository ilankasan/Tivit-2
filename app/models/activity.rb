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
  
  attr_accessible :name, :description, :status, :due,:owner_id, :users, :completed_at, :summary
# each Tivit has many participants 
  has_and_belongs_to_many :users

# every activity has many document asign to it
  has_many :activity_documents
  #has_many :documents, :through => :activity_documents 



# each tivit has many comments
  has_many :tivitcomments

# each tivit has many user status (show the specific status for each user)
  has_many :tivit_user_statuses
  

  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :description, :length => { :maximum => 1024 }
  validates :owner_id, :presence => true
   
 # validates_inclusion_of :status, :in => %w(in-progress Completed),
  #  :message => "%{value} is not a valid status"


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
	#puts self.users.inspect
#	puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	
#ilan: not 100% we ned the save option
		
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
  	if(status == "New" || status == "new")
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

#returns the status of a user with respect to this activity and this activity 

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
  
  
  

  
	

 def clean_user_invitees
 #clean users accept the task owber
 	owner = self.get_owner
 	self.users = [owner]

  end	


 def get_owner
 #adding the user to the existing users on the task
		return User.find_by_id(self.owner_id)
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
