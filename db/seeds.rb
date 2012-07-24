# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


puts "starting seed.....if production check that previous seed was run"
if(false)
puts "changing to not started"
  i = 1
  changed = 0
  strange = 0
  count = Activity.all.count
  puts "total tivits with activities is"+count.to_s
  
  
  count = Activity.where(:activity_type => 'tivit', :status_id => TivitStatus.get_in_progress_id ).count
  puts "Processing total tivits = "+count.to_s
  
  Activity.where(:activity_type => 'tivit',:status_id => TivitStatus.get_in_progress_id).each do |tivit|
      
      if(tivit.status_id == TivitStatus.get_in_progress_id)
        tivit_user_status = tivit.tivit_user_statuses.find_by_user_id(tivit.owner_id).status_id
        
        puts i.to_s+" id = "+tivit.id.to_s+", owner = "+tivit.owner_id.to_s+", tivit_user_status = "+tivit_user_status.to_s
        
   
        if(TivitStatus.is_reviewed_id?(tivit_user_status) || TivitStatus.is_new_id?(tivit_user_status) )
          tivit.change_status_id(TivitStatus.not_started_id)
          puts  "Changes to not started"
          changed = changed + 1   
        else 
          
        end
      end 
      i = i + 1 
  end # end each
  puts "Total tivits changed "+changed.to_s
  puts "Total strange " +strange.to_s

end
if (true)
puts "starting seed close status...if production check that "
  i = 1
  changed = 0
  strange = 0
  count = Activity.all.count
  puts "total tivits with activities is"+count.to_s
  
  
  count = Activity.where(:activity_type => 'tivit').count
  puts "total tivits is "+count.to_s
  
  Activity.where(:activity_type => 'tivit').each do |tivit|
      
      if(tivit.get_parent != nil)
        
        if(TivitStatus.is_completed_id?(tivit.get_parent.status_id))
          
          if(TivitStatus.is_in_progress_id?(tivit.status_id) || tivit.is_not_started?)
          
              tivit.change_status_id_to_closed
              changed = changed +1
              puts i.to_s+" tivit " +tivit.id.to_s+" closed!"
          else
              puts i.to_s+" tivit " +tivit.id.to_s+" stays completed"
          end
           
        else 
          if(tivit.get_parent.status_id == TivitStatus.get_closed_id)
            puts  i.to_s+" activity is closed !!!!!!!!!!!!!!!!!!!!!!"
            tivit.get_parent.status_id =  TivitStatus.get_completed_id
            tivit.get_parent.save
            strange = strange +1
            
          else
            puts  i.to_s+" tivit " +tivit.id.to_s+ " parent is in progress"
          end
        end
       
      else
        puts  i.to_s+" Parent for " +tivit.id.to_s+" is nil"
      end
      i = i + 1 
  end # end each
  puts "Total tivits changed "+changed.to_s
  puts "Total strange " +strange.to_s
  
end

if(false)
  i = 1
  User.all.each do |user|
      clone = "nil" if user.clone_email == nil  
      clone = user.clone_email  if user.clone_email != nil
      
      if(user.account != nil)
        user.clone_email = user.account.email
        puts i.to_s+" saving "+user.account.email+ " in to "+ clone.to_s
        user.save
      else
        puts i.to_s+" no account to email "+ clone.to_s
      
      end
       
      i = i + 1 
  end
end

if(false)
  puts "Migrating tivit_user_statuses...."

  count  = 0
  issues = 0
  totalrecords = TivitUserStatus.all.count
  puts "Total record "+ totalrecords.to_s  
  
  TivitUserStatus.all.each do |userstatus|
      count = count +1
      case userstatus.status_id_str
        when ("New") 
          userstatus.status_id = TivitStatus.get_new_id
          puts count.to_s+ " New"          
                
        when ("OnIt") 
        
          userstatus.status_id = TivitStatus.get_onit_id
          puts count.to_s+ " On it"          
          
         
        when ("Proposed") 
          userstatus.status_id = TivitStatus.get_proposed_id
          puts count.to_s+ " Proposed"          
           
        when ("Reviewed") 
          userstatus.status_id = TivitStatus.get_reviewed_id
          puts count.to_s+ " Reviewed"
                    
        when ("Reassigned")
          userstatus.status_id = TivitStatus.get_reassigned_id
          puts count.to_s+ " Reasigned"          
        
        when ("Done") 
          userstatus.status_id = TivitStatus.get_completed_id
          puts count.to_s+ " Done"
          
        when ("Reminded") 
          userstatus.status_id = TivitStatus.get_reminded_id
          puts count.to_s+ " Reminded"
          
        when ("Declined") 
          userstatus.status_id = TivitStatus.get_declined_id
          puts count.to_s+ " Declined"
          
        when ("Accepted") 
          userstatus.status_id = TivitStatus.get_accepted_id
          puts count.to_s+ " Accepted"
          
        else
          puts "----------------------> un identified status --->>. "+userstatus.status_id_str.to_s
          issues = issues + 1
        end
        userstatus.save
      
  end
  puts "total records "+totalrecords.to_s
  puts "modified "+count.to_s+" records"
  puts "found "+issues.to_s + " issues"


end
if(false)
  puts "starting seed....."
puts "geting activities"

 Activity.all.each do |activity|
      if(activity.status == "in-progress")
         activity.status_id = TivitStatus.get_in_progress_id
         puts "Replacing in progress"
      elsif (activity.status == "Completed") 
        activity.status_id = TivitStatus.get_completed_id
        puts "Replacing completed"
      else
         puts "----------->>>>>   NO STATUS !!!!!!!!!"
      end
      activity.save
  
  end
  
  puts "verification......"
  
  Activity.all.each do |activity|
    
      if(activity.status == "in-progress")
         if(TivitStatus.is_in_progress_id?(activity.status_id))
            puts "Check ok!!!"
         else
           puts "-------------------------->>>>>>>>>>>>  ERRORORORORORORORORO  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! in progress"
         end
      elsif(activity.status == "Completed")
      
        if(TivitStatus.is_completed_id?(activity.status_id))
            puts "Check ok!!!"
        else
           puts "-------------------------->>>>>>>>>>>>  ERRORORORORORORORORO  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! completed"
        end
    
        puts "Replacing in progress"
      end
end
  end
 
      
  