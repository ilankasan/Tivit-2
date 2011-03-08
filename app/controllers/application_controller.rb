class ApplicationController < ActionController::Base
#changing in master  
  protect_from_forgery
  include SessionsHelper
  include ActivitiesHelper
  include UsersHelper
  
end
