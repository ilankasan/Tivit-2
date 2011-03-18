FirstApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  


cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  #ilan changeed below from truw to fales
  config.action_view.debug_rjs             = false
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  # Host name
  #config.host_url = {
  	#:localhost = "localhost",
  	#:port      = "3000"} 
  
  # config/environments/development.rb
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
	  :address        => 'smtp.gmail.com',
	  :port           => 25,
	  :domain         => 'gmail.com',
	  :authentication => :login,
	  :user_name      => 'tiviti.mailer',
	  :password       => 'gotiviti'

  }
  
 # Paperclip.options[:command_path] = "/some/path/to"
  
  
  #config.gem "rmagick", :lib => "RMagick"  
end

