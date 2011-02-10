# == Schema Information
# Schema version: 20110205233830
#
# Table name: activities
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  status      :string(255)
#  due         :datetime
#  owner_id    :integer(4)
#  who         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#


class Activity < ActiveRecord::Base
  
  attr_accessible :name, :description, :status, :due,:owner_id, :users
  
  has_and_belongs_to_many :users

  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :description, :length => { :maximum => 1024 }
  validates :owner_id, :presence => true
  #validates_inclusion_of :status, :in => %w('in progress' completed),
   # :message => "%{value} is not a valid status"


  default_scope :order => 'activities.created_at DESC'

# Update status of theusers invites tot he activity
  def add_user_invites(user)
 #adding the user to the existing users on the task
	self.users << user
	
#ilan: not 100% we ned the save option
	self.save
		
	
  end	

  def update_user_invitee(user)
 #replacing user 
	self.users = [user]
	
#ilan: not 100% we ned the save option
	self.save
		
	
  end	



end
