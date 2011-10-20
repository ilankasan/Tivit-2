module AuthenticationServicesHelper
	
		
	def get_fb_email(params)
	  if params['email'] == nil
	  	return ''
	  else
	  	return params['email']
	  end 
	end
	
    def get_fb_name(params)
      if params['name'] == nil
	  	return ''
	  else
	  	return params['name']
	  end 
	end
    
    def get_fb_uid(params)
	  uid = params['urls']["extra"]["user_hash"]["id"]
	  if uid == nil 
	  	return ''
	  else
	  	return uid
	  end
	end
     
      
end
