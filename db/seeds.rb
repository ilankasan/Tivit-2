# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


puts "starting seed....."
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
 
      
  