require 'faker'

namespace :db do
  puts "starting"
  desc "Fill database with sample data"
  task :populate => :environment do
    
  puts "rake reset"
  
    Rake::Task['db:reset'].invoke
    puts "---------------    create admin  --------------"
  
    admin = User.create!(:name => "Ilan (Admin)",
                 :email => "ilan1@test.com",
                 :password => "111111",
                 :password_confirmation => "111111")
    admin.toggle!(:admin)
  
  puts "---------------    after reset --------------"
  
     
   
    
    3.times do |n|
      name  = Faker::Name.name
      email = "ilank-#{n+1}@test.com"
      
    puts "Inserting " +email
      
   user = User.create!(:name => name,:email => email,:password => "111111",
                 :password_confirmation => "111111")
      
   puts "---->>> Associating task #{n} to user #{user.id} = " + user.name 
   time1 = Time.now
   time1 =+ 100
   #if(time1.day > 29)
   #	time1.day = 1
   #end
   user.activities.create!(:description => "task description", :name => name+"-task #{user.id}.1",:owner_id => user.id,:due => time1, :status => "In Progress")
   user.activities.create!(:description => "task description",:name => name+"-task #{user.id}.2",:owner_id => user.id,:due => time1, :status => "In Progress" )                 
                 
    end
    puts "---->>>"
    
    User.all.each do |user1|
    puts "Inserting task for user #{user1.id} = " + user1.name 
    
    Activity.all.each do |tivit|
    	  puts "Atmpting to inserting task #{tivit.owner_id} for user #{user1.id} = " + user1.name 
      
          if(user1.id!=tivit.owner_id && tivit.description !=nil)
             puts "Success !  task #{tivit.id} to user #{user1.id}"
               
#            ActivityUser.create!(:activity_id =>tivit.id,:user_id => user1.id)     
			 #user1.activities.build({:activity_id =>tivit.id})
			 #testtask = user1.activities.build(:id =>tivit.id)
			 puts "Success !  task #{tivit.id}" +  user1.activities.inspect
			 if(user1.activities.instance_of?(Array))
			 	puts " ---->> an array "
			 end
			
			 									 
			
			 user1.activities << tivit
			 user1.save
			 
			 puts "Success !  task #{tivit.id}" 

        #     tivit.create_user(:user_id => user1.id)
             #user1.activitiesbuild(tivit)
            
          end
       
        #user.activities.create!(:content => user.name+"-task #{t}")
      end       
      end
    #end
    puts "end.........."
 # ActivityUser.create!(:activity_id=>"1",:user_id=>"2")
 # ActivityUser.create!(:activity_id=>"3",:user_id=>"2") 
   
  end
    
  
  end