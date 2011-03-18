require 'carrierwave/orm/activerecord'
class ProfileImage < ActiveRecord::Base
	
	  attr_accessible :user_id
 
	  mount_uploader :avatar, AvatarUploader

end
