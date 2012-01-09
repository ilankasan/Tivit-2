# == Schema Information
# Schema version: 20110301074306
#
# Table name: tivitcomments
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  comment     :string(255)
#  activity_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime

# Action Field is the type of comments:
# Note - ordinary user comments
# New 		- never read by the user
# Reviewed  - REviewed by the User
# OnIt      - The user agreed to do the tivit
# Done      - User has completed the Tivit
# Declined  - User declined to do the tivit for some reason
# Proposed  - user proposes a change in the tivit (initially a new date)
# Accepted  - Tiviti Owner Accepter the tivit	 

class Tivitcomment < ActiveRecord::Base
	attr_accessible :status_id, :activity_id,:user_id,:comment, :created_at,:action
	belongs_to :activity
	belongs_to :user
	
	validates :comment,  :presence => true
     
     
  # Returns true is this tivit was reviewed in the past and false if did not.
  # The way it is determined is by looking at when the user last reviewed the activity page and the date the comment creates  
  def wasReviewed?(user)
     tivit_user_status = self.activity.tivit_user_statuses.find_by_user_id(user.id)
     if (tivit_user_status != nil && tivit_user_status.last_reviewed != nil)
       if (self.user.id != user.id && self.created_at > tivit_user_status.last_reviewed)
         puts "___________________________________________________________________________"
         puts "was Revewed ----->>>>>>    user "+user.id.to_s+" did not review this comment"
         puts "___________________________________________________________________________"
             
         return false 
       else
         # puts "[Yaniv] Found new comment for logged in user!"
         return true
       end
         
     else
       puts "someting is fishi!"
       return true
     end
      
  end
                 
end
