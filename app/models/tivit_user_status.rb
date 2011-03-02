class TivitUserStatus < ActiveRecord::Base

	
attr_accessible :status_id, :activity_id,:user_id
		
	belongs_to :activity
	belongs_to :user

end
