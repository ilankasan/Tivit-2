# == Schema Information
# Schema version: 20110130100605
#
# Table name: activities
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  status      :string(255)
#  due         :datetime
#  user_id     :integer
#  who         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Activity < ActiveRecord::Base
  
  attr_accessible :name, :description, :status, :due
  
  belongs_to :user
  
  
  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :description, :length => { :maximum => 1024 }
  validates :user_id, :presence => true

  default_scope :order => 'activities.created_at DESC'

end
