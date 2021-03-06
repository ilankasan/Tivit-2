class LastReviewed < ActiveRecord::Base
#module ids
  attr_accessible :when, :user_id,:module_id 
  @completed_tasks = 1
  
  def self.get_last_updated_completed_tasks(user)
   # puts "--->>> get_last_updated_completed_tasks"
    lr = LastReviewed.where(:user_id => user.get_id, :module_id => @completed_tasks).first
   # puts last review
    if(lr == nil)
      return user.account.last_sign_in_at  
    else
    #  puts "retrning when = "+lr.when.to_s
      return lr.when
    end  
      
  end
  
  
  def self.update_completed_tasks_module(user)
    #puts "--->>> update_completed_module"
    lr = LastReviewed.where(:user_id => user.get_id, :module_id => @completed_tasks).first
    if(lr == nil)
      lr = LastReviewed.new(:user_id => user.get_id, :module_id => @completed_tasks,:when => Time.now())
      lr.save
      
    else
      lr.when = Time.now()
      lr.save
      #lr.save
      
     
    end
    #puts "---<<< update_completed_module"
    
  end
  
end
