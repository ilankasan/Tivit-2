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
    51.times do |n|
      name  = Faker::Name.name
      email = "ilank-#{n+1}@test.com"
      password  = "111111"
    puts "Inserting " +email  
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    puts "after  " +email  
                   
  end
    
    puts "before pupolate tasks"
    User.all(:limit => 49).each do |user|
      2.times do
        user.activities.create!(:name => Faker::Lorem.sentence(5))
             
      end
    end 
  end
end