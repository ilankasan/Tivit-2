class ApplicationController < ActionController::Base
#changing in master  
  protect_from_forgery
  #include SessionsHelper
  include ActivitiesHelper
  include UsersHelper
  include PagesHelper
  
   #rescue_from(Exception) { 
   
  #  EMAIL_QUEUE << {:email_type => "notify_error_occured"}
    
 # }

  
end
