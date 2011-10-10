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
  
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
 # config.action_mailer.default_url_options = { :host => 'tiviti.heroku.com' }
  
  
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
#  CarrierWave.configure do |config|
  	#config.storage_engines = :file
  	#config.storage = :file	
 # end
  
 # CarrierWave.configure do |config|
#  config.s3_access_key_id = 'AKIAJHY36IP6D642ZGQQ'
#  config.s3_secret_access_key = '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'
#  config.s3_bucket = 'tiviti-heroku'
#  config.s3_access_policy = :public_read
 # config.s3_headers = {'Cache-Control' => 'max-age=315576000'}
#  config.s3_region = 'us-east-1'
#  config.s3_cnamed = true
#end

  
  
#   CarrierWave.configure do |config|
 #     config.fog_credentials = {
  #      :provider               => 'AWS',       # required
   #     :aws_access_key_id      => 'AKIAJHY36IP6D642ZGQQ',       # required
    #    :aws_secret_access_key  => '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',       # required
        #:region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
     # }
      #config.fog_directory  = 'tiviti-heroku'                     # required
      #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
  #    config.fog_public     = false                                   # optional, defaults to true
      #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
   # end
  
 # Paperclip.options[:command_path] = "/some/path/to"
  
  
  #config.gem "rmagick", :lib => "RMagick"  
end

