# == Schema Information
# Schema version: 20110219220858
#
# Table name: activities
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  description  :string(255)
#  status       :string(255)
#  due          :datetime
#  owner_id     :integer(4)
#  who          :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  completed_at :datetime
#


class Activity < ActiveRecord::Base
  
  attr_accessible :name, :description, :status, :due,:owner_id, :users, :completed_at
# each Tivit has many participants 
  has_and_belongs_to_many :users
  
# each tivit has many comments
  has_many :tivitcomments

# each tivit has many user status (show the specific status for each user)
  has_many :tivit_user_statuses
  

  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :description, :length => { :maximum => 1024 }
  validates :owner_id, :presence => true
  #validates_inclusion_of :status, :in => %w('in progress' completed),
   # :message => "%{value} is not a valid status"
  validates_inclusion_of :status, :in => %w(in-progress completed),
    :message => "%{value} is not a valid status"


  default_scope :order => 'activities.created_at DESC'

# Update status of theusers invites tot he activity
  def add_user_invitee(user)
 #adding the user to the existing users on the task
	self.users << user
	puts "&&&&&&&&&&&&&        updating user task status &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	
	
	self.update_user_tivit_status(user)
	puts self.users.inspect
	puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	
#ilan: not 100% we ned the save option
		
	
  end	

  def update_user_tivit_status(user)
 	#tivit_status = user.get_tivit_status(self)
 	#if(tivit_status == nil)
 	
 	
 	puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	puts "((&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&)((((((((((((((((())))))))))))))))))))))))"
	puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	
 	tivit_status = create_status_new(user)
 	puts "creating a task with status new"	
 		
 	#end
 		
  end
  
  
  
  def get_status(user)
  	tivit_user_status = self.tivit_user_statuses.find_by_user_id(user.id)
  	if(tivit_user_status == nil)
  		tivit_user_status = create_status_new(user)
 		
  	end
    return tivit_user_status.status_id
 	
  end
	

 def clean_user_invitees
 #clean users accept the task owber
 	owner = User.find_by_id(self.owner_id)
 	self.users = [owner]
	
  end	

private
 def create_status_new(user)
 		tivit_status = user.tivit_user_statuses.new()
 		tivit_status.status_id = "New"
 		tivit_status.activity_id = self.id
 		tivit_status.save()
 		return tivit_status 
  
  end 
  
 
end
