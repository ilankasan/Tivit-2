require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Ilan (Admin)",
                 :email => "ilan@test.com",
                 :password => "111111",
                 :password_confirmation => "111111")
    admin.toggle!(:admin)
    
    99.times do |n|
      name  = Faker::Name.name
      email = "ilan-#{n+1}@test.com"
      password  = "111111"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    
    
    
  end
end


require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Ilan (Admin)",
                 :email => "ilan1@test.com",
                 :password => "111111",
                 :password_confirmation => "111111")
    admin.toggle!(:admin)
    
    99.times do |n|
      name  = Faker::Name.name
      email = "ilan-#{n+1}@test.com"
      password  = "111111"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    
    
    User.all(:limit => 6).each do |user|
      50.times do
        user.activities.create!(:name => Faker::Lorem.sentence(5))
             
      end
    end 
  end
end