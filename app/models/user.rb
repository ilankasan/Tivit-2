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
  has_many :last_reviewed
  
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

  
  
  def update_reviewed_completed_tasks
      LastReviewed.update_completed_tasks_module(self)
  end 
    
  def get_num_new_completed_since_last_reviewed
   puts "get_num_new_completed_since_last_reviewed"
   #self.activities()
   return Activity.where("status_id = ? AND activity_type = 'tivit' AND (owner_id = ? OR invited_by = ?) AND completed_at > ?",TivitStatus.get_completed_id, self.id, self.id, LastReviewed.get_last_updated_completed_tasks(self)).count

  end
  
  def is_activity_zero?
# return true is user was never assigned a task, created an activity or assign a task
   
   return false if(self.activities.size > 0)
   
   return false if(Activity.where("invited_by = ?",self.get_id).count > 0)
   
   
   return true
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
  	else
  	   #add code to change the update code so we can track user you recently interacted with
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
  #  puts "get_new_tasks_assign_to_me "+r.size.to_s
    return r
  end
  
  def get_open_tasks_assign_to_me  (other_user)
    r = self.activities.where(:status_id => TivitStatus.get_in_progress_id,:invited_by => other_user.get_id)
    #with_date     = self.activities.where("status_id = ? AND invited_by = ? AND due not null",TivitStatus.get_in_progress_id, other_user.get_id).order(:due)
    #without_date  = self.activities.where(:status_id => TivitStatus.get_in_progress_id,:invited_by => other_user.get_id,:due => nil)
    
    #return with_date+without_date 
     #  puts "get_open_tasks_assign_to_me "+r.size.to_s
    return r
  end
  
  def get_last_ten_completed_tasks_assign_to_me  (other_user)
    r = self.activities.where(:status_id => TivitStatus.get_completed_id,:invited_by => other_user.get_id).order(:completed_at).limit(10)
    # .paginate(:page => params[:page], :per_page => 30)
    puts "get_last_ten_completed_tasks_assign_to_me "+r.size.to_s
    return r
  end
  
  def get_num_completed_tasks_assign_to_me  (other_user)
    return self.activities.where(:status_id => TivitStatus.get_completed_id,:invited_by => other_user.get_id).count
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
  
  def get_num_completed_tasks_i_assign  (other_user)
    return  other_user.get_num_completed_tasks_assign_to_me (self) 
  end
  
  def get_num_open_tasks_i_assigned
    
        return Activity.joins(:parent).where("(activities.status_id = ? OR activities.status_id = ?)   
                             AND      activities.activity_type    = 'tivit'
                             AND NOT  activities.owner_id         = ?
                             AND      activities.invited_by       = ?
                             AND NOT  parents_activities.status_id  = ?
                    ",TivitStatus.get_in_progress_id,TivitStatus.not_started_id ,self.id,self.id,TivitStatus.get_completed_id).count
  end
  
  
  def get_num_my_open_tasks
      
      return Activity.joins(:parent).where("activities.status_id     = ?   
                                AND activities.activity_type = 'tivit'
                                AND activities.owner_id      = ?
                                AND NOT  parents_activities.status_id  = ?
                    ",TivitStatus.get_in_progress_id,self.id,TivitStatus.get_completed_id).count
  end
  
  private
                    
end
