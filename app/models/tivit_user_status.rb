# == Schema Information
# Schema version: 20110301074306
#
# Table name: tivit_user_statuses
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  activity_id :integer(4)
#  status_id   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class TivitUserStatus < ActiveRecord::Base

	
attr_accessible :status_id, :activity_id,:user_id
		
	belongs_to :activity
	belongs_to :user

end
