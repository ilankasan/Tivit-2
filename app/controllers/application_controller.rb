class ApplicationController < ActionController::Base
#changing in master  
  protect_from_forgery
  #include SessionsHelper
  include ActivitiesHelper
  include UsersHelper
  include PagesHelper
  
   rescue_from(Exception) { 
   # Or just handle particular exceptions
   # do stuff
  }

  
end
