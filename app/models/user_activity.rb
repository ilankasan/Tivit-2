class UserActivity < ActiveRecord::Base
  
  # attr_accessible :user_id, :activity_id
  #belongs_to :task, :class_name => "Activity"
  belongs_to :user
  belongs_to :activity
  
end
