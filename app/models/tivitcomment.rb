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
#

class Tivitcomment < ActiveRecord::Base
	attr_accessible :status_id, :activity_id,:user_id,:comment
	belongs_to :activity
	belongs_to :user
end
