class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ActivitiesHelper
  include UsersHelper
end
