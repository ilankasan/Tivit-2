# == Schema Information
# Schema version: 20110219231906
#
# Table name: tivitcomments
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  comment     :text
#  activity_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class Tivitcomment < ActiveRecord::Base
	attr_accessible :status_id, :activity_id,:user_id
	belongs_to :activity
	belongs_to :user
end
