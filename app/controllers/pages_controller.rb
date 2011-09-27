class PagesController < ApplicationController
  
  def home
    @title = "Home"
    if signed_in?      
# returns all activities that are not completed abd i either own or i have a a tivit (tivit can be completed or not)
   		current_user_id = current_user.get_id.inspect

      	sql_activities_i_participate = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
      				   WHERE NOT activities.status      = 'Completed'  
      				   AND activities.activity_type 	= 'activity' 
      				   AND (activities.owner_id    		= "+current_user_id+"
      				   OR ( 
      				   tivits.owner_id 			= "+current_user_id+" 
      				   AND tivits.parent_id 	= activities.id))
      				   ORDER BY activities.due"
      				           
      	@tivits_participate = Activity.find_by_sql(sql_activities_i_participate)
      	
      	
# Return all new activities
      	sql_new_tivits_old = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses 
      				   WHERE NOT activities.status         = 'Completed' 
      				   AND activities.activity_type 	   = 'activity' 
      				   AND   NOT activities.owner_id       = "+current_user_id+" 
      				   AND tivit_user_statuses.activity_id = activities.id 
      				   AND tivit_user_statuses.status_id   = 'New' 
      				   AND tivit_user_statuses.user_id     = "+current_user_id+"
      				   ORDER BY activities.due"
      				   
      				   
      sql_new_tivits_old2 = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses
      				   WHERE NOT activities.status      = 'Completed'  
      				   AND activities.activity_type 	= 'activity' 
      				   AND 
      				   (    activities.owner_id    		= "+current_user_id+"
      				   	AND tivit_user_statuses.activity_id = activity.id 
      				    AND tivit_user_statuses.status_id   = 'New' 
      				    AND tivit_user_statuses.user_id     = "+current_user_id+"
      				   
      				   		OR 
      				   		(    tivits.owner_id 	= "+current_user_id+" 
      				   		 AND tivits.parent_id 	= activities.id
      				   		 AND tivit_user_statuses.activity_id = tivits.id 
      				   		 AND tivit_user_statuses.status_id   = 'New' 
      				   		 AND tivit_user_statuses.user_id     = "+current_user_id+"
      				   		 )
      				   )
      				   ORDER BY activities.due"
################################# NEW ACTITVITIES #######################################################################################
	  sql_new_tivits = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses
      				   WHERE NOT activities.status         = 'Completed'  
      				   AND activities.activity_type 	   = 'activity' 
      				   AND tivits.owner_id 				   = "+current_user_id+" 
      				   AND tivits.parent_id 			   = activities.id
      				   AND tivit_user_statuses.activity_id = tivits.id 
      				   AND tivit_user_statuses.status_id   = 'New' 
      				   AND tivit_user_statuses.user_id     = "+current_user_id+"
      				   ORDER BY activities.due"
	 
	 
	  @tivits_new          = Activity.find_by_sql(sql_new_tivits)
	  
	  
	  
################################# Completed ACTITVITIES #######################################################################################
	  
	  sql_completed_activities = "SELECT DISTINCT activities.* FROM activities, activities as tivits 
      				   WHERE activities.status      = 'Completed'  
      				   AND activities.activity_type 	= 'activity' 
      				   AND (activities.owner_id    		= "+current_user_id+"
      				   OR ( 
      				   tivits.owner_id 			= "+current_user_id+" 
      				   AND tivits.parent_id 	= activities.id))
      				   ORDER BY activities.due"
      				           
      	@tivits_completed = Activity.find_by_sql(sql_completed_activities)
      	
################################# Need Attension #######################################################################################
	  	sql_need_attention_activities = "SELECT DISTINCT activities.* FROM activities, activities as tivits, tivit_user_statuses
      				   WHERE NOT activities.status         = 'Completed'  
      				   AND activities.activity_type 	   = 'activity' 
      				   AND tivits.owner_id 				   = "+current_user_id+" 
      				   AND tivits.parent_id 			   = activities.id
      				   AND tivit_user_statuses.activity_id = tivits.id 
      				   AND 
      				   (     tivit_user_statuses.status_id = 'New'
    				   	 OR tivit_user_statuses.status_id  = 'Proposed'
    				   )
    				   
 
      				   AND tivit_user_statuses.user_id     = "+current_user_id+"
      				   ORDER BY activities.due"
	 
	 
	  	@need_attention_activities          = Activity.find_by_sql(sql_need_attention_activities)
	  

      	
      	
     end
  end



def home_old
    @title = "Home"
    if signed_in?
    #  @activity = Activity.new #ilan:not sure this is needed
      
      #@tivits_owned       = current_user.activities.find_all_by_owner_id(current_user.get_id)
      
      #@tivits_owned       = current_user.activities.where("NOT status = ? AND owner_id = ?"    ,"Completed", current_user.get_id)
      #@tivits_participate = current_user.activities.where("NOT status = ? AND NOT owner_id = ?","Completed", current_user.get_id)
      
#this SQL retrieves all new tivits for me eccpet the ones i am the owner
	  current_user_id = current_user.get_id.inspect
   #   sql_new_tivits = "SELECT activities.* FROM activities, tivit_user_statuses WHERE NOT activities.owner_id = "+current_user_id+" AND tivit_user_statuses.activity_id = activities.id AND tivit_user_statuses.status_id = 'New' AND tivit_user_statuses.user_id = "+current_user_id
      sql_new_tivits = "SELECT DISTINCT activities.* FROM activities, tivit_user_statuses 
      				   WHERE NOT activities.status         = 'Completed' 
      				   AND   NOT activities.owner_id       = "+current_user_id+" 
      				   AND tivit_user_statuses.activity_id = activities.id 
      				   AND tivit_user_statuses.status_id   = 'New' 
      				   AND tivit_user_statuses.user_id     = "+current_user_id
	 
	  @tivits_new          = Activity.find_by_sql(sql_new_tivits)
      #@tivits_completed       = current_user.activities.where("status = 'Completed' AND completed_at > ?",)
      #@tivits_completed       = current_user.activities.where("status = 'Completed'")
      
      end
  end

  
  def activities
    @title = "Activities"
  end

  def myteam
    @title = "My Team"
  end

  def signout
     @title = "tiviti - Sign in"
  end

  def myaccount
     @title = "My Account"
  end
   
  def about
     @title = "About"
  end

end
