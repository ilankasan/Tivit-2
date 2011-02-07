# == Schema Information
# Schema version: 20110206213020
#
# Table name: user_activities
#
#  id          :integer(4)      not null, primary key
#  activity_id :integer(4)
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class UserActivity < ActiveRecord::Base
  
  # attr_accessible :user_id, :activity_id
  #belongs_to :task, :class_name => "Activity"
  belongs_to :user
  belongs_to :activity
  
end
