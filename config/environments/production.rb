FirstApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true
  #config.action_view.debug_rjs             = false

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
   config.log_level = :fatal

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true
  
  
  


 #config.action_mailer.default_url_options = { :host => 'tiviti-staging.heroku.com' }
 #config.action_mailer.asset_host          = "tiviti-staging.heroku.com"
    
 config.action_mailer.default_url_options = { :host => 'tiviti-s2.heroku.com' }
 config.action_mailer.asset_host          =            "tiviti-s2.heroku.com"


 #config.action_mailer.default_url_options = { :host => 'tiviti.heroku.com' }
 #config.action_mailer.asset_host          =            "tiviti.heroku.com"
  

  # Send deprecation notices to registered listeners
  config.active_support.deprecation          = :notify
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method       = :smtp
  config.action_mailer.smtp_settings         = {
	  :address        => 'smtp.gmail.com',
	  :port           => 25,
	  :domain         => 'gmail.com',
	  :authentication => :login,
	  :user_name      => 'tiviti.mailer',
	  :password       => 'gotiviti'

  }
  
  
  CarrierWave.configure do |config|
  config.s3_access_key_id = 'AKIAJHY36IP6D642ZGQQ'
  config.s3_secret_access_key = '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'
  config.s3_bucket = 'tiviti-heroku'
  config.s3_access_policy = :public_read
 # config.s3_headers = {'Cache-Control' => 'max-age=315576000'}
#  config.s3_region = 'us-east-1'
  config.s3_cnamed = true
end

end
