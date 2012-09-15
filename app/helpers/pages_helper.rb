module PagesHelper

  
def expand_new_request_ui?
  
  if @my_open_tasks == nil || (@my_open_tasks.size - @new_tivit_requests.size == 0)
    return true
  else
    return false
  end
end
    
def get_user_activity_notifications (user_id)
  puts "in get_user_notifications "
 # events = Activity.where("invited_by = ? AND NOT owner_id =? AND  (status_id = ? OR status_id = ?) ", 
  #                  user_id,user_id,TivitStatus.get_completed_id,TivitStatus.get_in_progress_id).order(:updated_at).reverse_order.limit(5)
  
  #puts "processing "+events.size.to_s+" events"
  
  
     #return Activity.where("status_id = ? AND activity_type = 'tivit' AND (owner_id = ? OR invited_by = ?)",TivitStatus.get_completed_id, user.get_id, user.get_id ).order(:completed_at).reverse_order.paginate(:page => params[:page], :per_page => 15)
     sql = "SELECT * FROM activities WHERE
                     invited_by = "+ user_id + " 
             AND NOT owner_id   = "+ user_id + "
             AND   (status_id   = "+TivitStatus.get_completed_id.to_s+" OR status_id = "+TivitStatus.get_in_progress_id.to_s+")  
           ORDER BY updated_at DESC LIMIT 5"
           
     #return Activity.where("status_id = ? AND activity_type = 'tivit' AND (owner_id = ? OR invited_by = ?)",TivitStatus.get_completed_id, user.get_id, user.get_id ).order(:completed_at).paginate(:page => params[:page], :per_page => 15)
     return Activity.find_by_sql(sql)
  
#  return events
  
end


  def get_tasks_for_other(current_user_id)
      puts "--->>> in get tasks for others"
   #   time = Time.now()
      in_progress_id = TivitStatus.get_in_progress_id.to_s
      
      without_date = Activity.where("     (status_id        = ? OR status_id        = ?)   
                             AND      activity_type    = 'tivit'
                             AND NOT  owner_id         = ?
                             AND      invited_by       = ?
                             AND due IS NULL
                    ",in_progress_id,TivitStatus.not_started_id ,current_user_id,current_user_id).order("created_at DESC").reverse_order
                    
       with_date = Activity.where("     (status_id        = ? OR status_id        = ?)   
                             AND      activity_type    = 'tivit'
                             AND NOT  owner_id         = ?
                             AND      invited_by       = ?
                              AND due IS NOT NULL
                    ",in_progress_id,TivitStatus.not_started_id ,current_user_id,current_user_id).order(" due, created_at DESC").reverse_order
      
   #   puts "number of tasks is = "+results1.size.to_s
    #  puts "<<<--- out get other tasks "+(Time.now()-time).to_s
    
       
    
      return with_date+without_date  
    end
 

def get_my_open_tasks(current_user_id)
      #puts "--->>> in my open tasks"
   #   time = Time.now()
      #not_started = TivitStatus.not_started_id
      #in_progress = TivitStatus.get_in_progress_id
  #    completed   = TivitStatus.get_completed_id.to_s
   #   new_id      = TivitStatus.get_new_id.to_s
    #  reviewed_id = TivitStatus.get_reviewed_id.to_s
      
      without_date = Activity.where("(status_id     = ? OR status_id     = ?)   
                    AND activity_type = 'tivit'
                    AND owner_id      = ?
                    AND due IS NULL
                    ",TivitStatus.not_started_id,TivitStatus.get_in_progress_id,current_user_id).order(:created_at).reverse_order
      with_date = Activity.where("(status_id     = ? OR status_id     = ?)   
                    AND activity_type = 'tivit'
                    AND owner_id      = ?
                    AND due IS NOT NULL
                    ",TivitStatus.not_started_id,TivitStatus.get_in_progress_id,current_user_id).order(:due).reverse_order
          
 #     puts "<<<--- out my open tasks "+(Time.now()-time).to_s
      return with_date+without_date
    end
###################
    
    def get_new_tivit_requests(current_user_id)
   #   puts "--->>> in get_new_tivit_requests"
    #  time = Time.now()
      
  # get activities with New and unread tivits  
      results1  =  Activity.where("status_id = ? AND owner_id = ? AND NOT invited_by = ?",TivitStatus.not_started_id,current_user_id,current_user_id)
    
      #puts "^^^^^^^^^^^^^^^^^   -------->>>>>>>>>>>>>>> R1 = "+results1.size.to_s
  #    puts "<<<--- out get_new_tivit_requests "+(Time.now()-time).to_s
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

  
  def get_activities_i_participate (user_id)
#all the activites the user either own OR participating in, ordered by date, closest one first, do not show the activities i have not accepted any tivit
  #  puts "_______________________________________________"
  #time = Time.now()
    
     if Rails.env.development?                     
      sql_activities_i_participate  = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
                 WHERE NOT activities.status_id         = "+TivitStatus.get_completed_id.to_s+"  
                 AND  activities.activity_type          = 'activity'
                 AND ((activities.owner_id               = "+user_id+") 
                      OR (     
                               tivits.parent_id                  = activities.id
                          AND  tivits.owner_id                   = "+user_id+"
                          AND  tivits.status_id             = "+TivitStatus.get_in_progress_id.to_s+ "
                          ))
                 ORDER BY  activities.due desc "
     else            
      sql_activities_i_participate  = "SELECT DISTINCT activities.*, ISNULL(activities.due) AS 'isnull' FROM activities, activities as tivits 
                 WHERE NOT activities.status_id         = "+TivitStatus.get_completed_id.to_s+"  
                 AND  activities.activity_type          = 'activity'
                 AND ((activities.owner_id              = "+user_id+") 
                      OR (     
                               tivits.parent_id                  = activities.id
                          AND  tivits.owner_id                   = "+user_id+"
                          AND  tivits.status_id             = "+TivitStatus.get_in_progress_id.to_s+ "
                          ))
                 ORDER BY  isnull ASC, activities.due ASC"
 
      end                      
        activities_i_participate      = Activity.find_by_sql(sql_activities_i_participate)
      #  puts "activities_i_participate = "+activities_i_participate.size.to_s
       #  puts "<<<--- out activities_i_participate "+(Time.now()-time).to_s
        
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
    puts " --------->>>>>>>>>>>>>>> get_completed_tivits $$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
     #return Activity.where("status_id = ? AND activity_type = 'tivit' AND (owner_id = ? OR invited_by = ?)",TivitStatus.get_completed_id, user.get_id, user.get_id ).order(:completed_at).reverse_order.paginate(:page => params[:page], :per_page => 15)
     sql = "SELECT * FROM activities WHERE
               status_id     = "+TivitStatus.get_completed_id.to_s+"
           AND activity_type = 'tivit' 
           AND (owner_id = "+user.get_id.to_s+" OR invited_by = "+user.get_id.to_s+") 
           ORDER BY completed_at DESC"
           
     #return Activity.where("status_id = ? AND activity_type = 'tivit' AND (owner_id = ? OR invited_by = ?)",TivitStatus.get_completed_id, user.get_id, user.get_id ).order(:completed_at).paginate(:page => params[:page], :per_page => 15)
     return Activity.find_by_sql(sql).paginate(:page => params[:page], :per_page => 10)

  end



def get_activities_completed_or_with_completed_tivits(user_id)
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