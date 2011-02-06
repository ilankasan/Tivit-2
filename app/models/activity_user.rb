# == Schema Information
# Schema version: 20110205231819
#
# Table name: activity_users
#
#  id          :integer(4)      not null, primary key
#  activity_id :integer(4)
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class ActivityUser < ActiveRecord::Base
end
