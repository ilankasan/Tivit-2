

class TivitUserStatus < ActiveRecord::Base

# each tivit / activity has specific data and statuses tracked in relations to a specific users
# Status id values are: 
# New 		- never read by the user
# Reminded  - never read by the owner but at least one reminder was sent
# Reviewed  - REviewed by the User
# OnIt  - The user agreed to do the tivit
# Done      - User has completed the Tivit
# Declined  - User declined to do the tivit for some reason
# Proposed 
# Accepted	- 
# Reassigned  - 


attr_accessible :status_id, :activity_id,:user_id,:comment,:last_reviewed
		
	belongs_to :activity
	belongs_to :user


	def update_last_reviewed
		time = Time.now()
  		self.last_reviewed = time.utc
  		self.save
	end
end

	
