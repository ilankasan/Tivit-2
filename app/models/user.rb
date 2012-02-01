# == Schema Information
# Schema version: 20110309070830
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  email               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  encrypted_password  :string(255)
#  salt                :string(255)
#  admin               :boolean(1)
#  is_active           :boolean(1)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer(4)
#  avatar_updated_at   :datetime


require 'digest'

class User < ActiveRecord::Base
	
  #attr_accessor :user_email
  #attr_accessible :name, :email, :password, :password_confirmation, :is_active,:last_signin,:admin
  attr_accessible :name, :is_active,:admin,:account_id,:clone_email
  
  
# each user has many contacts
  has_many :contacts
  has_many :mycontacts, :through => :contacts, :class_name => "User"
  
  has_and_belongs_to_many :activities
  has_and_belongs_to_many :preferences
  
  
# each user has many user status (show the specific status for each task)
  has_many :tivit_user_statuses
  has_many :tivitcomments

  has_one :profile_image

  belongs_to :account 
  
   
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
   
  
  def autoname
  end
  
  
  def isAdmin?
 # ilan need to rewrite
    email = self.account.email
    if(email =="ilan.kasan@gmail.com" || email =="yanivlevi1@gmail.com" || email =="jon.nakasone@gmail.com")
      return true
    else
      return false
    end
    #return self.admin
  end

  def deactivate_user
    self.is_active = false
  end
  
  def activate_user
    self.is_active = true
  end
  
  def is_active?
    return self.is_active 
  end
  
  def get_name
  	return self.name 		if  self.is_active
  	return self.clone_email if !self.is_active
  end
  
  def get_email
  	return self.clone_email    if  self.account.nil?
	  return self.account.email  if !self.account.nil?
	
  end
  
  def get_id
  	return self.id
  end
  
# check is use is a contact. Ifnot, adds it
  def addContact(user)
  	if(!self.isContact?(user))
  		self.mycontacts << user

  	end
  end
  
  def addTwoWayContact(user)
    return if(self == user)
    self.addContact(user)
    user.addContact(self)
  end
  
  def isContact?(user)
  	
  	return self.mycontacts.exists?(user)
  end
     
#builds a new activity to a user (as an owner)
def add_my_ativity (params)
 # settign owner Id to be rqual to the current user
 puts "---------------- add_my_ativity  ----------------------" 
 
   
   	params["owner_id"] = self.id
   	params["status"]   = "in-progress"
   	params["activity_type"]     = "activity"
 	
 	puts params.inspect	
# returns a new activity created from the parameters in hash
  	return  activities.create(params)		
   end

  private
                    
end
