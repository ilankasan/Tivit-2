class Preference < ActiveRecord::Base
  
  attr_accessible :preference
  has_and_belongs_to_many :users
  
  
  def init_preferences(prefs)
    puts "intializing prefereces!"
    
  end
  
end
