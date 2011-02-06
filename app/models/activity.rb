# == Schema Information
# Schema version: 20110205233830
#
# Table name: activities
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  status      :string(255)
#  due         :datetime
#  owner_id    :integer(4)
#  who         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#


class Activity < ActiveRecord::Base
  
  attr_accessible :name, :description, :status, :due,:owner_id
  
    has_and_belongs_to_many :users

  #has_many :users, :through => :user_activities
  
    
  
  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :description, :length => { :maximum => 1024 }
  validates :owner_id, :presence => true

  default_scope :order => 'activities.created_at DESC'

end
