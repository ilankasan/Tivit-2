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
	
  #attr_accessible :name, :email, :password, :password_confirmation, :is_active,:last_signin,:admin
  attr_accessible :name, :is_active,:admin,:account_id,:clone_email
  
  
# each user has many contacts
  has_many :contacts
  has_many :mycontacts, :through => :contacts, :class_name => "User"
  
  has_and_belongs_to_many :activities
  #has_and_belongs_to_many :preferences
  
  
# each user has many user status (show the specific status for each task)
  has_many :tivit_user_statuses
  has_many :tivitcomments

  has_one :profile_image

  belongs_to :account 
  
   
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
   
  def does_own_activity?
    activity = Activity.where(:activity_type => "activity", :owner_id => self.id).first
    if(activity == nil)
    #  puts "does_own_activity? = false"
       return false
    else
   #   puts "does_own_activity? = true"
       return true
    end
      
    
  end
  def get_account
    return self.account
  end
  
  def isAdmin?
 # ilan need to rewrite
    email = self.account.email
   #puts "Email is ---->>>>>> "+email
    if(email =="ilan.kasan@gmail.com"  || email =="yanivlevi1@gmail.com" )
     # puts "return true"
      return true
    else
      #puts "return false"
      
      return false
    end
    #return self.admin
  end
  
  def isSupperAdmin?
 # ilan need to rewrite
    email = self.account.email
    if(email =="ilan.kasan@gmail.com")
      return true
    else
      return false
    end
    #return self.admin
  end

  def deactivate_user
    self.is_active = false
    self.save
  end
  
  def activate_user
    self.is_active = true
    self.save
  end
  
  def isActive?
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

   	params["owner_id"] = self.id
   	params["status_id"]   = TivitStatus.get_in_progress_id
   	params["activity_type"]     = "activity"
  	return  activities.create(params)		
   end

  def get_new_tasks_assign_to_me  (other_user)
    r = self.activities.where(:status_id => TivitStatus.not_started_id,:invited_by => other_user.get_id)
    puts "get_new_tasks_assign_to_me "+r.size.to_s
    return r
  end
  
  def get_open_tasks_assign_to_me  (other_user)
    r = self.activities.where(:status_id => TivitStatus.get_in_progress_id,:invited_by => other_user.get_id)
    
    puts "get_open_tasks_assign_to_me "+r.size.to_s
    
    return r
  end
  
  def get_last_ten_completed_tasks_assign_to_me  (other_user)
    r = self.activities.where(:status_id => TivitStatus.get_completed_id,:invited_by => other_user.get_id).order(:completed_at).limit(10)
    #.paginate(:page => params[:page], :per_page => 5)
    # .paginate(:page => params[:page], :per_page => 30)
    puts "get_completed_tasks_assign_to_me "+r.size.to_s
    return r
  end
  
 #####################################################
  def get_new_tasks_i_assigned  (other_user)
    return other_user.get_new_tasks_assign_to_me (self) 
  end
  
  def get_open_tasks_i_assign  (other_user)
    
    return  other_user.get_open_tasks_assign_to_me (self) 

  end
  
  def get_last_ten_completed_tasks_i_assign  (other_user)
    return  other_user.get_last_ten_completed_tasks_assign_to_me (self) 

  end
  
  
  private
                    
end
