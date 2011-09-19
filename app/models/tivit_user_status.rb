# == Schema Information
# Schema version: 20110309070830
#
# Table name: tivit_user_statuses
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  activity_id :integer(4)
#  status_id   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  comment     :string(255)
#

class TivitUserStatus < ActiveRecord::Base

	
attr_accessible :status_id, :activity_id,:user_id,:comment,:last_reviewed
		
	belongs_to :activity
	belongs_to :user


	def update_last_reviewed
		time = Time.now()
  		self.last_reviewed = time.localtime
  		self.save
	end
end

	
