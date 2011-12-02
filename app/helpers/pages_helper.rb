module PagesHelper

  
  def get_my_activities(user_id)
    
      sql_my_activities = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE 
                 NOT activities.status          = 'Completed'  
                 AND activities.activity_type   = 'activity' 
                 AND activities.owner_id        = "+user_id+"
                 ORDER BY activities.due"
                         
        return Activity.find_by_sql(sql_my_activities)
        
  end
  
  
  
  
  def get_need_attention (user_id)
      sql_need_attention_activities = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses
                 WHERE NOT activities.status          = 'Completed'  
                 AND activities.activity_type       = 'activity' 
                 AND 
                 (
                  (   tivits.owner_id                 = "+user_id+" 
                  AND tivits.parent_id                = activities.id
                  AND tivit_user_statuses.activity_id = tivits.id 
                  AND 
                  (   tivit_user_statuses.status_id  = 'New'
                 OR tivit_user_statuses.status_id  = 'Proposed'
                 OR tivit_user_statuses.status_id  = 'Reviewed'
                 OR tivit_user_statuses.status_id  = 'Reminded'
                )
                 AND tivit_user_statuses.user_id   = "+user_id+")
               OR 
               (
                ( NOT tivits.owner_id                   = "+user_id+"
                    AND activities.owner_id             = "+user_id+"
                    AND tivits.parent_id                = activities.id
                    AND tivit_user_statuses.activity_id = tivits.id 
                    AND 
                  (   tivit_user_statuses.status_id  = 'Declined'
                 OR tivit_user_statuses.status_id  = 'Proposed'
                 )
                 
               )))
                 ORDER BY activities.due"
      
      return Activity.find_by_sql(sql_need_attention_activities)

  end
  
  def get_activities_i_participate (user_id)
    
      sql_activities_i_participate = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE NOT activities.status      = 'Completed'  
                 AND activities.activity_type   = 'activity' 
                 AND (activities.owner_id       = "+user_id+"
                 OR ( 
                 tivits.owner_id      = "+user_id+" 
                 AND tivits.parent_id   = activities.id))
                 ORDER BY activities.due"
                         
        return Activity.find_by_sql(sql_activities_i_participate)
        
  end
  
  def get_new_activities      
        sql_new_tivits_old = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
                 WHERE NOT activities.status         = 'Completed' 
                 AND activities.activity_type      = 'activity' 
                 AND   NOT activities.owner_id       = "+current_user_id+" 
                 AND tivit_user_statuses.activity_id = activities.id 
                 AND tivit_user_statuses.status_id   = 'New' 
                 AND tivit_user_statuses.user_id     = "+current_user_id+"
                 ORDER BY activities.due"
                 
                 
      sql_new_tivits_old2 = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses
                 WHERE NOT activities.status      = 'Completed'  
                 AND activities.activity_type   = 'activity' 
                 AND 
                 (    activities.owner_id       = "+current_user_id+"
                  AND tivit_user_statuses.activity_id = activity.id 
                  AND tivit_user_statuses.status_id   = 'New' 
                  AND tivit_user_statuses.user_id     = "+current_user_id+"
                 
                    OR 
                    (    tivits.owner_id  = "+current_user_id+" 
                     AND tivits.parent_id   = activities.id
                     AND tivit_user_statuses.activity_id = tivits.id 
                     AND tivit_user_statuses.status_id   = 'New' 
                     AND tivit_user_statuses.user_id     = "+current_user_id+"
                     )
                 )
                 ORDER BY activities.due"
                
################################# NEW ACTITVITIES #######################################################################################
    
    sql_new_tivits = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses
                 WHERE NOT activities.status         = 'Completed'  
                 AND activities.activity_type      = 'activity' 
                 AND tivits.owner_id           = "+current_user_id+" 
                 AND tivits.parent_id          = activities.id
                 AND tivit_user_statuses.activity_id = tivits.id 
                 AND tivit_user_statuses.status_id   = 'New' 
                 AND tivit_user_statuses.user_id     = "+current_user_id+"
                 ORDER BY activities.due"
   return Activity.find_by_sql(sql_new_tivits)
   
   end
    
    
    
################################# Completed ACTITVITIES #######################################################################################
# Returns activities completed the last 15 days
  def get_activities_completed(user_id)
    
    sql_completed_activities = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE activities.status      = 'Completed'  
                 AND activities.activity_type   = 'activity' 
                 AND (activities.owner_id       = "+user_id+"
                 OR ( 
                 tivits.owner_id      = "+user_id+" 
                 AND tivits.parent_id   = activities.id))
                 ORDER BY activities.due"
                         
        return Activity.find_by_sql(sql_completed_activities)
#AND activities.completed_at    > ? 15.days.ago  
  end               
         

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
