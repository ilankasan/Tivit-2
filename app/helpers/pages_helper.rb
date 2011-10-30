module PagesHelper
  def get_user_stats  
     activated         = User.where("is_active = ?", '1').count
     total_users       = User.count
     non_activated     = total_users - activated
     viraly_joined     = User.where("is_active = ? AND clone_email is not null", '1').count
      
     #puts "activated = "+activated.to_s+ " non activate = "+non_activated.to_s+ " total = "+total_users.to_s+ " viraly_joined = " + viraly_joined.to_s
    
     @user_adopt = {"activated" => activated.to_s, "non_activated" => non_activated.to_s, "total" => total_users.to_s, "viraly_joined" => viraly_joined.to_s}
     return @user_adopt
  end
  
  
  def get_tivits_stats
     activities         = Activity.where(:activity_type => "activity").count
     tivits             = Activity.count - activities 
     tmp                = Float (Float(tivits) /  Float(activities))
# display only two decimals
     avg_t_per_a        = Integer(tmp * 100) / Float(100)
     
     @tivits_stats = {"activities" => activities.to_s, "tivits" => tivits.to_s,  "avg_t_per_a" => avg_t_per_a.to_s}
     puts @tivits_stats .inspect 

     return @tivits_stats
    
  end
  
  
  
end
