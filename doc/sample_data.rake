require 'faker'


namespace :db do
  puts "starting"
  desc "Fill database with sample data"
  task :populate => :environment do
    
  puts "rake reset"
  
    Rake::Task['db:reset'].invoke
    
  puts "---------------    after reset --------------"
  
    admin = User.create!(:name => "Ilan (Admin)",
                 :email => "ilan1@test.com",
                 :password => "111111",
                 :password_confirmation => "111111")
    admin.toggle!(:admin)
  
  
    
    
  puts "after create uadmin " + admin.name  
    3.times do |n|
      name  = Faker::Name.name
      email = "ilank-#{n+1}@test.com"
      password  = "111111"
    puts "Inserting " +email  
    user  = User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    
    puts "---------   >>>> before pupolate tasks"
      
    user.activities.create!(:name => user.name+"-task 1" )
    user.activities.create!(:name => user.name+"-task 2" )
                   
    
   #  puts "-------->>>>>>>>>>>>  before ActivityCollabs"
 # UserActivity.create!(:activity_id=>"4",:user_id=>"1")
 # UserActivity.create!(:activity_id=>"3",:user_id=>"1") 
  puts "-------->>>>>>>>>>>>  end"
   
  end
end