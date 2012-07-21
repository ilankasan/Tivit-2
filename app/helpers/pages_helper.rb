module PagesHelper

  
  def delete_this_get_my_activities(user_id)
    
      sql_my_activities = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE 
                 NOT activities.status_id       = ?  
                 AND activities.activity_type   = 'activity' 
                 AND activities.owner_id        = "+user_id+"
                 ORDER BY activities.due"
                         
        return Activity.find_by_sql(sql_my_activities)
        
  end
    



def get_tasks_for_other(current_user_id)
      
      #puts "--->>> in get tasks for others"
      time = Time.now()
      
      in_progress_id = TivitStatus.get_in_progress_id.to_s
      
      results1 = Activity.where("     status_id        = ?  
                             AND      activity_type    = 'tivit'
                             AND NOT  owner_id         = ?
                             AND      invited_by       = ?
                    ",in_progress_id,current_user_id,current_user_id).order(" due, created_at DESC")
      
      puts "number of tasks is = "+results1.size.to_s
      
      puts "<<<--- out get other tasks "+(Time.now()-time).to_s
      
      return results1  
    end
    



###################
    def get_my_open_tasks(current_user_id)
      
      #puts "--->>> in my open tasks"
      time = Time.now()
      
      completed   = TivitStatus.get_completed_id.to_s
      new_id      = TivitStatus.get_new_id.to_s
      reviewed_id = TivitStatus.get_reviewed_id.to_s
      
      results1 = Activity.where("(status_id     = ? OR status_id     = ?)   
                    AND activity_type = 'tivit'
                    AND owner_id      = ?
                    ",TivitStatus.not_started_id,TivitStatus.get_in_progress_id,current_user_id).order(" due, created_at DESC")
     
      puts "<<<--- out my open tasks "+(Time.now()-time).to_s
      
      return results1
       
    end
    
    def get_new_tivit_requests(current_user_id)
      #puts "--->>> in get_new_tivit_requests"
      time = Time.now()
      
  # get activities with New and unread tivits  
      
        
      
      results1  =  Activity.where(:status_id => TivitStatus.not_started_id, :owner_id => current_user_id  )
    
      #puts "^^^^^^^^^^^^^^^^^   -------->>>>>>>>>>>>>>> R1 = "+results1.size.to_s
      puts "<<<--- out get_new_tivit_requests "+(Time.now()-time).to_s
      
    #  puts results1.inspect
      return results1 
  end

  def delete_this_get_new_tivit_requests(current_user_id)
      #puts "--->>> in get_new_tivit_requests"
      time = Time.now()
      
  # get activities with New and unread tivits  
      completed   = TivitStatus.get_completed_id.to_s
      new_id      = TivitStatus.get_new_id.to_s
      reviewed_id = TivitStatus.get_reviewed_id.to_s
      declined_id = TivitStatus.get_declined_id.to_s
      proposed_id = TivitStatus.get_proposed_id.to_s
  
        
      sql_new_tivit_requests = "SELECT DISTINCT tivits.* FROM  activities as tivits, tivit_user_statuses 
                   WHERE NOT tivits.status_id             = "+completed+"  
                   AND  tivits.activity_type              = 'tivit' 
                   AND  tivits.owner_id                   = "+current_user_id+"  
                   AND  NOT tivits.invited_by             = "+current_user_id+"  
                   AND  tivits.owner_id                   = tivit_user_statuses.user_id 
                   AND  tivits.id                         = tivit_user_statuses.activity_id 
                   AND  (tivit_user_statuses.status_id    = "+new_id+" 
                      OR tivit_user_statuses.status_id    = "+reviewed_id+")
                   ORDER BY tivits.due"
    #OR tivit_user_statuses.status_id    = "+proposed_id+"
      results1  =  Activity.find_by_sql(sql_new_tivit_requests)
    
      #puts "^^^^^^^^^^^^^^^^^   -------->>>>>>>>>>>>>>> R1 = "+results1.size.to_s
      puts "<<<--- out get_new_tivit_requests "+(Time.now()-time).to_s
      
    #  puts results1.inspect
      return results1 
  end
  
    
    
  def get_activities_with_new_tivit_requests(current_user_id)
  # get activities with New and unread tivits  
  completed   = TivitStatus.get_completed_id.to_s
  new_id      = TivitStatus.get_new_id.to_s
  reviewed_id = TivitStatus.get_reviewed_id.to_s
  declined_id = TivitStatus.get_declined_id.to_s
  proposed_id = TivitStatus.get_proposed_id.to_s
  
        
     sql_activities_with_my_tivits = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
                   WHERE NOT activities.status_id      = "+completed+"  
                   AND  activities.activity_type       = 'activity' 
                   AND  tivits.owner_id                = "+current_user_id+"  
                   AND  tivits.parent_id               = activities.id  
                   AND  tivits.owner_id                = tivit_user_statuses.user_id 
                   AND  tivits.id                      = tivit_user_statuses.activity_id 
                   AND  (tivit_user_statuses.status_id = "+new_id+" OR tivit_user_statuses.status_id = "+reviewed_id+")
                   AND  NOT tivits.status_id           = "+completed+"
                   ORDER BY activities.due"
    
      results1  =  Activity.find_by_sql(sql_activities_with_my_tivits)
 #     puts "-------->>>>>>>>>>>>>>> R1 = "+results1.size.to_s
      
      
      sql_activities_i_assigned_with_tivit_requests = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
                   WHERE NOT activities.status_id        = "+completed+"  
                   AND     activities.activity_type      = 'activity'
                   AND     tivits.invited_by             = "+current_user_id+" 
                   AND NOT tivits.owner_id               = "+current_user_id+"  
                   AND     tivits.parent_id              = activities.id  
                   AND     tivits.owner_id               = tivit_user_statuses.user_id 
                   AND     tivits.id                     = tivit_user_statuses.activity_id 
                   AND  ( tivit_user_statuses.status_id  = "+declined_id+" OR tivit_user_statuses.status_id  = "+proposed_id+")
                   AND  NOT tivits.status_id             = "+completed+"
                 
                   ORDER BY activities.due"
    
                 
      results2  =  Activity.find_by_sql(sql_activities_i_assigned_with_tivit_requests)
 #     puts "-------->>>>>>>>>>>>>>> R2 = "+results2.size.to_s
      
      
      return (results2 + results1).uniq 
  
      #puts "number of activities with incoming tivits = "+results.size.to_s
  end

  def old_get_activities_i_participate (user_id)
#all the activites the user either own OR participating in, ordered by date, closest one first, do not show the activities i have not accepted any tivit
    puts "_______________________________________________"
    puts "get_activities_i_participate "
    puts "_______________________________________________"
    
      sql_activities_i_participate_no_due_date = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE NOT activities.status_id   = "+TivitStatus.get_completed_id.to_s+"
                 AND activities.due               IS NULL    
                 AND activities.activity_type     = 'activity' 
                 AND (activities.owner_id         = "+user_id+"
                 OR (
                 tivits.owner_id        = "+user_id+" 
                 AND tivits.parent_id   = activities.id))"
                 
      sql_activities_i_participate_with_due_date = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE NOT activities.status_id   = "+TivitStatus.get_completed_id.to_s+"  
                 AND activities.activity_type     = 'activity' 
                 AND activities.due IS NOT           NULL
                 AND (activities.owner_id         = "+user_id+"
                 OR (
                 tivits.owner_id        = "+user_id+" 
                 AND tivits.parent_id   = activities.id))
                 ORDER BY activities.due"
      
                          
  
                              
                            
        activities_i_participate_with_due_date      = Activity.find_by_sql(sql_activities_i_participate_with_due_date)
     #   puts "with date = "+activities_i_participate_with_due_date.inspect
        activities_i_participate_without_due_date   = Activity.find_by_sql(sql_activities_i_participate_no_due_date)
    #    puts "without date = "+activities_i_participate_without_due_date.inspect
        
        return activities_i_participate_with_due_date + activities_i_participate_without_due_date
        
  end

  
  def get_activities_i_participate (user_id)
#all the activites the user either own OR participating in, ordered by date, closest one first, do not show the activities i have not accepted any tivit
  #  puts "_______________________________________________"
  time = Time.now()
    puts "_______________________________________________"
    
    puts "NEW get_activities_i_participate "
    puts "_______________________________________________"
    
                          
     sql_activities_i_participate  = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE NOT activities.status_id         = "+TivitStatus.get_completed_id.to_s+"  
                 AND  activities.activity_type          = 'activity'
                 AND ((activities.owner_id               = "+user_id+") 
                      OR (     
                               tivits.parent_id                  = activities.id
                          AND  tivits.owner_id                   = "+user_id+"
                          AND  tivits.status_id             = "+TivitStatus.get_in_progress_id.to_s+ "
                          ))
                 ORDER BY  activities.due ASC "
                 
 #    puts sql_activities_i_participate
                              
     temp_delete_sql_activities_i_participate  = "SELECT DISTINCT activities.*, ISNULL(activities.due) AS 'isnull' FROM activities, activities as tivits, tivit_user_statuses 
                 WHERE NOT activities.status_id        = "+TivitStatus.get_completed_id.to_s+"  
                 AND activities.activity_type          = 'activity' 
                 AND tivits.owner_id                   = "+user_id+"
                 AND tivits.parent_id                  = activities.id
                 AND tivit_user_statuses.activity_id   = tivits.id 
                 AND NOT (tivits.status_id             = "+TivitStatus.get_new_id.to_s+" OR 
                          tivits.status_id             = "+TivitStatus.get_declined_id.to_s+") 
                
                 AND tivit_user_statuses.user_id       = "+user_id+"
                 ORDER BY  isnull ASC, activities.due ASC "
                              
                            
                            
        activities_i_participate      = Activity.find_by_sql(sql_activities_i_participate)
      #  puts "activities_i_participate = "+activities_i_participate.size.to_s
         puts "<<<--- out activities_i_participate "+(Time.now()-time).to_s
        
        return activities_i_participate
        
  end
  
  
  
  def get_activities_i_have_open_tivits(user_id)
    #puts "get_activities_i_have_open_tivits"
    
      sql_activities_i_participate_with_due_date  = "SELECT DISTINCT activities.*, ISNULL(tivits.due) AS 'isnull' FROM activities, activities as tivits, tivit_user_statuses 
                 WHERE NOT activities.status_id           = "+TivitStatus.get_completed_id.to_s+"  
                 AND activities.activity_type          = 'activity' 
                 AND tivits.owner_id                   = "+user_id+"
                 AND tivits.parent_id                  = activities.id
                 AND tivit_user_statuses.activity_id   = tivits.id 
                 AND NOT tivits.status_id                 = "+TivitStatus.get_completed_id.to_s+" 
               
                 AND tivit_user_statuses.user_id       = "+user_id+"
                 ORDER BY  isnull ASC, tivits.due ASC "
                          
        activities_i_participate_with_due_date      = Activity.find_by_sql(sql_activities_i_participate_with_due_date)
        
        return activities_i_participate_with_due_date 
  end
  
  
  def get_new_activities      
                 
                
################################# NEW ACTITVITIES #######################################################################################
    
    sql_new_tivits = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses
                 WHERE NOT activities.status_id         = "+TivitStatus.get_completed_id.to_s+"  
                 AND activities.activity_type      = 'activity' 
                 AND tivits.owner_id           = "+current_user_id+" 
                 AND tivits.parent_id          = activities.id
                 AND tivit_user_statuses.activity_id = tivits.id 
                 AND tivit_user_statuses.status_id   = "+TivitStatus.get_new_id.to_s+" 
                 AND tivit_user_statuses.user_id     = "+current_user_id+"
                 ORDER BY activities.due"
   return Activity.find_by_sql(sql_new_tivits)
   
   end
    
    
    
################################# Completed ACTITVITIES #######################################################################################

  def get_completed_tivits(user)
  #  puts " --------->>>>>>>>>>>>>>> get_completed_tivits $$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
  
    return user.activities.where(:status_id => TivitStatus.get_completed_id,:activity_type => 'tivit' ).order(:completed_at).reverse.paginate(:page => params[:page], :per_page => 10)
  end



def get_activities_completed_or_with_completed_tivits(user_id)
    #puts "------>>>>  get_activities_completed_or_with_completed_tivits <<<<<<<<<<________________"
    
          
    
    sql_completed_activities_or_with_completed_tivits = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE 
                 activities.activity_type   = 'activity' 
                 AND (
                          (activities.status_id = "+TivitStatus.get_completed_id.to_s+" AND activities.owner_id = "+user_id+")
                    OR ( 
                             tivits.parent_id       = activities.id 
                             AND tivits.owner_id    = "+user_id+"  
                             AND tivits.status_id      = "+TivitStatus.get_completed_id.to_s+")
                      )
                 ORDER BY tivits.completed_at DESC"
                
     @completed_activities = Activity.find_by_sql(sql_completed_activities_or_with_completed_tivits).paginate(:page => params[:page], :per_page => 5)
    
    
    puts ">>  get_activities_completed_or_with_completed_tivits << size = "+@completed_activities.size.to_s
     
      return @completed_activities
  end


def delete_this_get_activities_completed_or_with_completed_tivits(user_id)
    #puts "------>>>>  get_activities_completed_or_with_completed_tivits <<<<<<<<<<________________"
    sql_completed_activities_or_with_completed_tivits = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE (activities.status_id       = "+TivitStatus.get_completed_id.to_s+"  
                 AND activities.activity_type   = 'activity' 
                 AND (activities.owner_id       = "+user_id+"
                 OR ( 
                 tivits.owner_id      = "+user_id+" 
                 AND tivits.parent_id   = activities.id)))
                 OR
                 (NOT activities.status_id      = "+TivitStatus.get_completed_id.to_s+"  
                 AND activities.activity_type   = 'activity' 
                 AND ((activities.owner_id       = "+user_id+")
                 OR (tivits.owner_id      = "+user_id+" AND tivits.parent_id   = activities.id)))
                 ORDER BY tivits.completed_at DESC"
                 #ORDER BY activities.due ASC DESC"
     
     @completed_activities = Activity.find_by_sql(sql_completed_activities_or_with_completed_tivits).paginate(:page => params[:page], :per_page => 60)
     #puts "1. ------>>>>  "+completed_activities.inspect
      return @completed_activities
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
  #   puts @tivits_stats .inspect 

     return @tivits_stats
    
  end
  




  
  
end
