class  MyDevise::RegistrationsController < Devise::RegistrationsController
                 
   
 before_filter :authenticate_account!, :except=>[:awaiting_confirmation,:after_inactive_sign_up_path_for]
 skip_before_filter :authenticate_account!, :only => [:awaiting_confirmation,:after_inactive_sign_up_path_for]                                                 
 
  def new
  	puts " new ++++++++++++ registration ++++++++++++++++++++++++++++++++++++++"
   
    @email = params[:email]
	 if(@email != nil)
	   puts "Sign up with email "+@email
	 #   flash[:warning] = "Sign up with email "+@email
	 end
	 @title = "Sign Up"
	 
	#account_session[:user_email] = @email
   super
    
  end

   def update
     	puts "UUUUUUPPPPPDDDATE"
 #  	puts params.inspect
	
    super
  end

 
 def create
 	puts "-------->>>>>>>>>> In Regitration Create Controller <<<<<<<<<<<<<<------------------"
 	@params = params
   
  if(params[:account][:viral] == "true" )
    puts " viral !!!!!!!!!!!!!!!!!!!!!!!!!"
    email    = params[:account][:email]
    puts " viral mail "+email
    
    EMAIL_QUEUE << {:email_type => "notify_new_user", :email => params[:account][:email], :type => "Viral Signup"}
    
    password = params[:account][:password]
    name     = params[:account][:user][:name]
    puts " viral name = "+name+"pass = "+password
    
    @account = Account.new :email => email , :password => password , :fullname => name
    @user = User.where(:is_active => false,  :clone_email => email).first
              
    #@user = @users[0] if @users.size > 0
        
   # puts "user = "+@user.get_name
    if(@user == nil)
                puts "user == nil"
                @account.user = User.new({:name=>name, :clone_email => email})
    else
      puts "user != nil"
      if(@account.user == nil)
          puts " account.user == nil"
          @user.activate_user
          @user.name    = name
          @user.save
          @account.user = @user
      else
        puts " account.user != nil"
      end
    end
                    # do not send confirmation email, we directly save and confirm the new record
    @account.user.activate_user
    @account.skip_confirmation!
    @account.save!
    @account.confirm!

    
    sign_in_and_redirect(:account, @account)
    #flash[:myinfo] = 'Your account on tiviti has been created via ' + provider.capitalize + '. In your profile you can change your personal information and add a local password.'
  else
#----------------------------------------------------------#
#--------------------- user is not joining virally
#----------------------------------------------------------#
     puts " --  no viral --  "
     email = params[:account][:email]
     puts "email = "+email
   #  @account = Account.find_by_email(email)
     
  	 super
  	 
     @account = Account.find_by_email(email)
     puts "-------->>>>>>>>>> In Regitration Create Controller not viral <<<<<<<<<<<<<<------------------ 3"
# fist find the user clone
  	 @user = User.where("clone_email = ?",email).first
  	 #@user = @users[0] if @users.size > 0
  	
  	#puts "user = "+@user.inspect
  	if(@user == nil)
  		puts "user == nil and email = "+email
  		params[:account][:user][:clone_email] = email 
  		@account.user = User.new(params[:account][:user])
  		puts "-------->>>>>>>>>> In Regitration Create Controller <<<<<<<<<<<<<<------------------ 4"
  	  EMAIL_QUEUE << {:email_type => "notify_new_user", :email => params[:account][:email], :type => "New user signup"}
  	else
  		puts "user already exists != nil"
  		if(@account.user == nil)
  			puts " account.user == nil"
  			@user.activate_user
  			@user.name    = params[:account][:user][:name]
  			@user.save
  			@account.user = @user
  		else
		  	puts " account.user != nil"
		  end
	  end
	puts " saving account!!!!!!!!!!!!!!!!"
	@account.save!
	

	end
#  account_session[:sign_in] = "true" 
 end
 
 
 
 
 def awaiting_confirmation
   #puts "params = "+params.inspect
   puts "awaiting_confirmation" 
   @account = Account.find_by_id(params[:format])
   
   #puts "email " + @email.inspect
   
   if( @account.confirmed_at != nil && false)
      render 'pages/home'
   else
      render 'awaiting_confirmation'
   end
   return
   
 end
 protected
 def after_inactive_sign_up_path_for(resource)
   
   puts "in after_inactive_sign_up_path_for"
   
   puts params.inspect
   email = params[:account][:email]
   
   
   @account = Account.find_by_email(email)
   if( params[:account][:viral] == "true" && false)
      puts "confirmed_at != nil"
      sign_in_and_redirect(:account, @account)
     # render 'pages/home' 
   else
      awaiting_confirmation_url (resource)
   end
  
 end
  
end  