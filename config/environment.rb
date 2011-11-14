# Load the rails application
require File.expand_path('../application', __FILE__)



# Initialize the rails application
FirstApp::Application.initialize!
ActionMailer::Base.delivery_method = :smtp
 
ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 25,
   :domain => "gmail.com",
   :authentication => :login,
   :user_name => "tiviti.mailer@gmail.com",
   #:user_name => "tiviti.ilan.kasan@gmail.com",
   
   :password => "gotiviti",
   
#   :address        => 'smtpout.secureserver.net',
#    :port           => 25,
#    :domain         => 'tiviti.net',
#    :authentication => :login,
#    :user_name      => 'tiviti.mailer@tiviti.net',
#    :password       => 'tiviti'

}


 
