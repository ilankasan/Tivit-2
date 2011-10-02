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
#



require 'digest'

class User < ActiveRecord::Base
	
  attr_accessor :password,:user_email
  attr_accessible :name, :email, :password, :password_confirmation, :is_active,:last_signin,:admin
  
  
# each user has many contacts
  has_many :contacts
  has_many :mycontacts, :through => :contacts, :class_name => "User"
  
  has_and_belongs_to_many :activities
  
# each user has many user status (show the specific status for each task)
  has_many :tivit_user_statuses
  has_one :profile_image

  
 
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
 
                    
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
                    
                    
# Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 1..40 }
                    
       
  before_save :encrypt_password
  
  def funky_method
  	puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    "#{self.name}.camelize"
  end

  
  def get_autocomplete_items(parameters)
    items = super(parameters)
    items = items.where(:user_id => current_user.id)
  end
  
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
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
  	if(self.is_active == false)
  		return self.email
  	else
    	return self.name
    end 
  end
  
  def get_id
  	return self.id
  end
  
# check is use is a contact. Ifnot, adds it
  def addContect(user)
  	puts "addContect"
  	if(!self.isContact?(user))
  		#self.contacts.create(:user_id => self.id, :contact_id => user.get_id)
  		self.mycontacts << user

  	end
  end
  
  def isContact?(user)
  	
  	return self.mycontacts.exists?(user)
  end
   
  def update_last_signin
  		puts "PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP"
  		time = Time.now()
  		self.last_signin = time.localtime
  	#	self.admin       = true
  		#attr = Hash.new
  	#	attr = {"last_signin" => time.localtime}
  		#attributes = ["last_signin"][time.localtime]
  		puts "updatting last sign in !!!!!!!!!!!!!!!!!!!!!!!!! name " + name+"    time = "+self.last_signin.inspect
  	#	puts attr.inspect
  	#	self.update_attributes(attr)
  		self.save()
  
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  
  
  #def feed
    # This is preliminary. See Chapter 12 for the full implementation. this is same at activities
    #config.debug("Retriving Activities for user id = #{id}" )
   # puts "----------------Retriving users" 
  
  #  Activity.where("user_id = ?", id)
  	#return activities
  #end
  
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

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
       secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end       
                    
end
