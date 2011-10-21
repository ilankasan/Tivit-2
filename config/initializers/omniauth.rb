Rails.application.config.middleware.use OmniAuth::Builder do
 #provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
 provider :twitter, 'RzO86jtopIkEAludN2gdg', 'JJ6hHnuhs1JcCwuXt5t9DnD5R6GEVC0i1l76tenqTL4'
 
########################################################################################## 
 #provider :facebook, 'local host'
 #provider :facebook, '223270434403133', '08c76edf24f62d71a732cd8818140b62'
 
#provider :facebook, 'heroku'
 provider :facebook, '261808970530645', '3c67e54b6ceb8d2f316c0c99ecbd63b0'
##########################################################################################
 #provider :github, 'CLIENT ID', 'SECRET'
 provider :github, '681ef4a52f33b237f7b8', 'cb1efb799d24a3e52baee03e5554c3b53d3c2a32'
 
 
 # Google sign in
 require 'openid/store/filesystem'
 provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id' 
 
  
   
end