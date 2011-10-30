module PagesHelper
  def get_user_stats  
     activated         = User.where("is_active = ?", '1').count
     total_users       = User.count
     non_activated     = total_users - activated
     viraly_joined     = User.where("is_active = ? AND clone_email is not null", '1').count
      
     #puts "activated = "+activated.to_s+ " non activate = "+non_activated.to_s+ " total = "+total_users.to_s+ " viraly_joined = " + viraly_joined.to_s
     puts @user_adopt.inspect 

     @user_adopt = {"activated" => activated.to_s, "non_activated" => non_activated.to_s, "total" => total_users.to_s, "viraly_joined" => viraly_joined.to_s}
     return @user_adopt
  end
end
