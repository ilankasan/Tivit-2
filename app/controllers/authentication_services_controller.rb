class AuthenticationServicesController < ApplicationController
	  
	    before_filter :authenticate_account!, :except => [:create]

def index
  # get all authentication services assigned to the current user
  @services = current_account.authentication_services.all
end

def destroy
  # remove an authentication service linked to the current user
  @service = current_account.authentication_services.find(params[:id])
  @service.destroy
  
  redirect_to authentication_services_path
end

def create
	puts "Create!!!! "+params.inspect
        
  # get the service parameter from the Rails router
  #params[:service] ? service_route = params[:service] : service_route = 'no service (invalid callback 1)'

  # get the full hash from omniauth
  omniauth = request.env['omniauth.auth']
  omniauth["provider"] ? service_route = omniauth["provider"] : service_route = 'no service (invalid callback 1)'

  puts " omni auth = "+omniauth.inspect

  # continue only if hash and parameter exist
  if omniauth 
   puts "check point 1"
   puts " Service route = "+service_route
     
    # map the returned hashes to our variables first - the hashes differ for every service
    if service_route == 'facebook'
     puts " Facebook"
     email       = get_fb_email(omniauth)
     name        = get_fb_name (omniauth)
     uid         = get_fb_uid  (omniauth)
     provider    = service_route
     
    elsif service_route == 'github'
    	puts " git hub not supported"
    	
    elsif service_route == 'twitter'
      puts " twitter not supported"
    	
    	
   	elsif service_route == 'google'
   		  puts " google sign in"
    
       omniauth['user_info']['email'] ? email =  omniauth['user_info']['email'] : email = ''
       omniauth['user_info']['name'] ? name =  omniauth['user_info']['name'] : name = ''
       omniauth['uid'] ? uid =  omniauth['uid'] : uid = ''
       omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
    else
      # we have an unrecognized service, just output the hash that has been returned
      render :text => omniauth.to_yaml
      #render :text => uid.to_s + " - " + name + " - " + email + " - " + provider
      puts "un identified service !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      return
    end
  
    # continue only if provider and uid exist
    if uid != '' and provider != ''
      #  puts "user id not nil"
        puts "email = "+email+" name = "+name+" uid = "+uid+" provider = "+provider
        
        
      # nobody can sign in twice, nobody can sign up while being signed in (this saves a lot of trouble)
      if !account_signed_in?
        puts "in after AuthenticationService uid = "+uid
        
        # check if user has already signed in using this service provider and continue with sign in process if yes
        auth = AuthenticationService.find_by_provider_and_uid(provider, uid)
        puts "in after AuthenticationService Auth = "+auth.inspect
        if auth
          
       #   flash[:notice] = 'Signed in successfully via ' + provider.capitalize + '.'
          puts "sign_in_and_redirect"
          sign_in_and_redirect(:account, auth.account)
        else
          # check if this user is already registered with this email address; get out if no email has been provided
          puts "account does not exist email = "+email
          
          if email != ''
            # search for a user with this email address
            existingaccount = Account.find_by_email(email)
            if existingaccount
              puts "existingaccount no nil"
              # map this new login method via a service provider to an existing account if the email address is the same
              existingaccount.authentication_services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
              flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account ' + existingaccount.email + '. Signed in successfully!'
              sign_in_and_redirect(:account, existingaccount)
            else
              # let's create a new user: register this user and add this authentication method for this user
              puts "creating a new account"
              name = name[0, 39] if name.length > 39             # otherwise our user validation will hit us

              # new user, set email, a random password and take the name from the authentication service
              account = Account.new :email => email, :password => SecureRandom.hex(10), :fullname => name

              # add this authentication service to our new account
              account.authentication_services.build(:provider => provider, :uid => uid, :uname => name, :uemail => email)
              
              # finding if a user already exists for this account. Ilan: need to create one method for this
              #@users = User.where("is_active = false AND clone_email = ?",email)
              @users = User.where(:is_active => false,  :clone_email => email)
              
      			  @user = @users[0] if @users.size > 0
      	
			        puts "user = "+@user.inspect
      			  if(@user == nil)
      					puts "user == nil"
      					account.user = User.new({:name=>name, :clone_email => email})
      				else
      					puts "user != nil"
      				if(account.user == nil)
      					puts " account.user == nil"
      					@user.activate_user
      					@user.name    = name
      					@user.save
      					account.user = @user
      				else
      					puts " account.user != nil"
      				end
      			end
    		            # do not send confirmation email, we directly save and confirm the new record
    		  account.user.activate_user
					
              account.skip_confirmation!
              account.save!
              account.confirm!

              # flash and sign in
              flash[:myinfo] = 'Your account on tiviti has been created via ' + provider.capitalize + '. In your profile you can change your personal information and add a local password.'
              sign_in_and_redirect(:account, account)
            end
          else
          	puts "no email?"
            flash[:error] =  service_route.capitalize + ' can not be used to sign-up on tiviti as no valid email address has been provided. Please use another authentication provider or use local sign-up. If you already have an account, please sign-in and add ' + service_route.capitalize + ' from your profile.'
            redirect_to new_account_session_path
          end
        end
      else
        # the user is currently signed in
        
        # check if this service is already linked to his/her account, if not, add it
        auth = AuthenticationService.find_by_provider_and_uid(provider, uid)
        if !auth
          current_account.authentication_services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
          flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account.'
          #redirect_to authentication_services_path
          #redirect_back_or root_path
          redirect_to root_path
        else
          flash[:notice] = service_route.capitalize + ' is already linked to your account.'
          #redirect_to authentication_services_path
          redirect_to root_path
        end  
      end  
    else
      flash[:error] =  service_route.capitalize + ' returned invalid data for the user id.'
      redirect_to new_account_session_path
    end
  else
    flash[:error] = 'Error while authenticating via ' + authentication_service_route.capitalize + '.'
    puts "redirect_to new_account_session_path" 
    redirect_to new_account_session_path
  end
end
private
def get_fb_email(params)
  if params["user_info"]['email'] == nil
  	return ''
  else
  	return params["user_info"]['email']
  end 
end

def get_fb_name(params)
	if params["user_info"]['name'] == nil
	 	return ''
	else
	  	return params["user_info"]['name']
	end 
end
    
    def get_fb_uid(params)
	  uid = params["uid"]
	  if uid == nil 
	  	return ''
	  else
	  	return uid
	  end
	end

end