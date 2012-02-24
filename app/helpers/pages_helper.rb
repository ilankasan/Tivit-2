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
                  ( tivit_user_statuses.status_id  = 'Declined' OR tivit_user_statuses.status_id  = 'Proposed')
                 
               )))
                 ORDER BY activities.due"
      
      return Activity.find_by_sql(sql_need_attention_activities)

  end
#  Other's activity:
#Only show the activity if I have a tivit there and it's not completed yet. 
#If I completed all my tivits in others activity, 
#only show it if other tivits I participated in the discussion had new comments or someone commented it my tivit. 
#Otherwise, don't show the activity at all.
#My tivits should show up at the top
#Only show other team tivits IF I ever participated in the discussion and there's a status change or new comment there
#Don't show closed/completed activities

#My Activities
#Always show all my Activites that are not closed - so I could close it
#Show the following tivits in each activity:
#Not completed (basically everything that is not yet completed - on it, in progress, late, etc.)
#Completed that had new comments on it


  def get_activities_with_new_tivit_requests(current_user_id)
  # get activities with New and unread tivits       
     sql_activities_with_my_tivits = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
                   WHERE NOT activities.status        = 'Completed'  
                   AND  activities.activity_type      = 'activity' 
                   AND  tivits.owner_id               = "+current_user_id+"  
                   AND  tivits.parent_id              = activities.id  
                   AND  tivits.owner_id               = tivit_user_statuses.user_id 
                   AND  tivits.id                     = tivit_user_statuses.activity_id 
                   AND  (tivit_user_statuses.status_id = 'New' OR tivit_user_statuses.status_id = 'Reviewed')
                   ORDER BY activities.due"
    
      results1  =  Activity.find_by_sql(sql_activities_with_my_tivits)
      puts "-------->>>>>>>>>>>>>>> R1 = "+results1.size.to_s
      
      
      sql_activities_i_assigned_with_tivit_requests = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
                   WHERE NOT activities.status           = 'Completed'  
                   AND     activities.activity_type      = 'activity'
                   AND     tivits.invited_by             = "+current_user_id+" 
                   AND NOT tivits.owner_id               = "+current_user_id+"  
                   AND     tivits.parent_id              = activities.id  
                   AND     tivits.owner_id               = tivit_user_statuses.user_id 
                   AND     tivits.id                     = tivit_user_statuses.activity_id 
                   AND  ( tivit_user_statuses.status_id  = 'Declined' OR tivit_user_statuses.status_id  = 'Proposed')
                   ORDER BY activities.due"
    
                 
      results2  =  Activity.find_by_sql(sql_activities_i_assigned_with_tivit_requests)
      puts "-------->>>>>>>>>>>>>>> R2 = "+results2.size.to_s
      
      
      return (results2 + results1).uniq 
  #    AND  (tivit_user_statuses.status_id = 'New' OR tivit_user_statuses.status_id = 'Reviewed')
                   
      #puts "number of activities with incoming tivits = "+results.size.to_s
      
    
  #  OLD_sql_activities_i_with_incomming_tivits = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
   #              WHERE NOT activities.status        = 'Completed'  
    #             AND  activities.activity_type      = 'activity' 
     #            AND  tivits.owner_id               = "+current_user_id+"  
      #           AND  tivits.parent_id              = activities.id  
       #          AND  tivits.owner_id               = tivit_user_statuses.user_id 
        #         AND  tivits.id                     = tivit_user_statuses.activity_id 
        #         AND  NOT (tivit_user_statuses.status_id = 'Done' OR tivit_user_statuses.status_id = 'OnIt')
         #        ORDER BY activities.due"
      
  end


  
  
  def get_activities_i_participate (user_id)
    
      sql_activities_i_participate_no_due_date = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE NOT activities.status      = 'Completed'
                 AND activities.due IS              NULL    
                 AND activities.activity_type     = 'activity' 
                 AND (activities.owner_id         = "+user_id+"
                 OR (
                 tivits.owner_id        = "+user_id+" 
                 AND tivits.parent_id   = activities.id))"
                 
      sql_activities_i_participate_with_due_date = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE NOT activities.status      = 'Completed'  
                 AND activities.activity_type     = 'activity' 
                 AND activities.due IS NOT           NULL
                 AND (activities.owner_id         = "+user_id+"
                 OR (
                 tivits.owner_id        = "+user_id+" 
                 AND tivits.parent_id   = activities.id))
                 ORDER BY activities.due"
                            
        activities_i_participate_with_due_date      = Activity.find_by_sql(sql_activities_i_participate_with_due_date)
        puts "with date = "+activities_i_participate_with_due_date.inspect
        activities_i_participate_without_due_date   = Activity.find_by_sql(sql_activities_i_participate_no_due_date)
        puts "without date = "+activities_i_participate_without_due_date.inspect
        
        return activities_i_participate_with_due_date + activities_i_participate_without_due_date
        
  end
  
  
  def old_get_activities_i_have_open_tivits(user_id)
    
      sql_activities_i_participate_with_due_date  = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
                 WHERE NOT activities.status           = 'Completed'  
                 AND activities.activity_type          = 'activity' 
                 AND activities.due IS NOT               NULL
                 AND tivits.owner_id                   = "+user_id+"
                 AND tivits.parent_id                  = activities.id
                 AND tivit_user_statuses.activity_id   = tivits.id 
                 AND NOT tivit_user_statuses.status_id = 'Done' 
                 AND tivit_user_statuses.user_id       = "+user_id+"
                 ORDER BY tivits.due"
                 
      sql_activities_i_participate_without_due_date  = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
                 WHERE NOT activities.status           = 'Completed'  
                 AND activities.activity_type          = 'activity'
                 AND activities.due IS                   NULL   
                 AND tivits.owner_id                   = "+user_id+"
                 AND tivits.parent_id                  = activities.id
                 AND tivit_user_statuses.activity_id   = tivits.id 
                 AND NOT tivit_user_statuses.status_id = 'Done' 
                 AND tivit_user_statuses.user_id       = "+user_id
                         
        activities_i_participate_with_due_date      = Activity.find_by_sql(sql_activities_i_participate_with_due_date)
        activities_i_participate_without_due_date   = Activity.find_by_sql(sql_activities_i_participate_without_due_date)
        
        return activities_i_participate_with_due_date + activities_i_participate_without_due_date
  end
  
  
  
  
  def get_activities_i_have_open_tivits(user_id)
    
      sql_activities_i_participate_with_due_date  = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
                 WHERE NOT activities.status           = 'Completed'  
                 AND activities.activity_type          = 'activity' 
                 
                 AND tivits.owner_id                   = "+user_id+"
                 AND tivits.parent_id                  = activities.id
                 AND tivit_user_statuses.activity_id   = tivits.id 
                 AND NOT tivit_user_statuses.status_id = 'Done' 
                 AND tivit_user_statuses.user_id       = "+user_id+"
                 ORDER BY  tivits.due ASC "
                 #NULLS LAST
                 
      sql_activities_i_participate_without_due_date  = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
                 WHERE NOT activities.status           = 'Completed'  
                 AND activities.activity_type          = 'activity'
                 AND activities.due IS                   NULL   
                 AND tivits.owner_id                   = "+user_id+"
                 AND tivits.parent_id                  = activities.id
                 AND tivit_user_statuses.activity_id   = tivits.id 
                 AND NOT tivit_user_statuses.status_id = 'Done' 
                 AND tivit_user_statuses.user_id       = "+user_id
                         
        activities_i_participate_with_due_date      = Activity.find_by_sql(sql_activities_i_participate_with_due_date)
      #  activities_i_participate_without_due_date   = Activity.find_by_sql(sql_activities_i_participate_without_due_date)
        
        return activities_i_participate_with_due_date 
  end
  
  def get_activities_i_have_unresponed_tivits(user_id)
    
      sql_activities_i_participate = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
                 WHERE NOT activities.status           = 'Completed'  
                 AND activities.activity_type          = 'activity' 
                 AND tivits.owner_id                   = "+user_id+"
                 AND tivits.parent_id                  = activities.id
                 AND tivit_user_statuses.activity_id   = tivits.id 
                 AND NOT tivit_user_statuses.status_id = 'Done' 
                 AND tivit_user_statuses.user_id       = "+user_id+"
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

def get_activities_completed_or_with_completed_tivits(user_id)
    #puts "------>>>>  get_activities_completed_or_with_completed_tivits <<<<<<<<<<________________"
    sql_completed_activities_or_with_completed_tivits = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE (activities.status      = 'Completed'  
                 AND activities.activity_type   = 'activity' 
                 AND (activities.owner_id       = "+user_id+"
                 OR ( 
                 tivits.owner_id      = "+user_id+" 
                 AND tivits.parent_id   = activities.id)))
                 OR
                 (NOT activities.status      = 'Completed'  
                 AND activities.activity_type   = 'activity' 
                 AND ((activities.owner_id       = "+user_id+")
                 OR (tivits.owner_id      = "+user_id+" AND tivits.parent_id   = activities.id)))
                 
                 ORDER BY activities.due DESC"
     completed_activities = Activity.find_by_sql(sql_completed_activities_or_with_completed_tivits)
     #puts "1. ------>>>>  "+completed_activities.inspect
      return completed_activities
  end


  def old_get_activities_completed_or_with_completed_tivits(user_id)
    #puts "------>>>>  get_activities_completed_or_with_completed_tivits <<<<<<<<<<________________"
    sql_completed_activities = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE activities.status      = 'Completed'  
                 AND activities.activity_type   = 'activity' 
                 AND (activities.owner_id       = "+user_id+"
                 OR ( 
                 tivits.owner_id      = "+user_id+" 
                 AND tivits.parent_id   = activities.id))
                 ORDER BY activities.due DESC"
     completed_activities = Activity.find_by_sql(sql_completed_activities)
     #puts "1. ------>>>>  "+completed_activities.inspect
    sql_activities_with_closed_tivits = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE NOT activities.status      = 'Completed'  
                 AND activities.activity_type   = 'activity' 
                 AND ((activities.owner_id       = "+user_id+")
                 OR (tivits.owner_id      = "+user_id+" AND tivits.parent_id   = activities.id))
                 ORDER BY activities.due DESC"
     activities_with_closed_tivits  = Activity.find_by_sql(sql_activities_with_closed_tivits)
    # puts "2. ------>>>>  "+activities_with_closed_tivits.inspect
    # puts "_________________________________________________"
                          
     return (completed_activities + activities_with_closed_tivits).uniq
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
