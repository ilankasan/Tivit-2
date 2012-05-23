# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

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
 
      
  