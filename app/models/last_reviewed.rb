class LastReviewed < ActiveRecord::Base
#module ids
  attr_accessible :when, :user_id,:module_id 
  @completed_tasks = 1
  
  def self.get_last_updated_completed_tasks(user)
    puts "--->>> get_last_updated_completed_tasks"
    lr = LastReviewed.where(:user_id => user.get_id, :module_id => @completed_tasks).first
    if(lr == nil)
      return user.account.current_sign_in_at  
    else
      puts "retrning when = "+lr.when.to_s
      return lr.when
    end  
      
  end
  
  
  def self.update_completed_tasks_module(user)
    puts "--->>> update_completed_module"
    lr = LastReviewed.where(:user_id => user.get_id, :module_id => @completed_tasks).first
    if(lr == nil)
      puts "new record"
      lr = LastReviewed.new(:user_id => user.get_id, :module_id => @completed_tasks,:when => Time.now())
      lr.save
      puts "new record"
      
    else
      puts "updating record"
      lr.when = Time.now()
      lr.save
      #lr.save
      
      puts "updating record"
    end
    puts "---<<< update_completed_module"
    
  end
  
end
