class  MyDevise::RegistrationsController < Devise::RegistrationsController
                 
   
 before_filter :authenticate_account!, :except=>[:awaiting_confirmation,:after_inactive_sign_up_path_for]
 skip_before_filter :authenticate_account!, :only => [:awaiting_confirmation,:after_inactive_sign_up_path_for]                                                 
 
  def new
  	puts " new ++++++++++++ registration ++++++++++++++++++++++++++++++++++++++"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	
  	puts "NNNNEEEEEEEEEEEEEEEEWWWWWWWWWWWWWWWWWWWWW"
	puts params.inspect
	@title = "Sign Up"
    
    super
    
  end

   def update
   	puts "update ++++++++++++++++++++++++++++++++++++++++++++++++++"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	
   	puts "UUUUUUPPPPPDDDATE"
   	puts params.inspect
	
    super
  end

 
 def create
 	puts "In Regitration Create Controller"
 #	puts " Params "+params.inspect
 	@params = params
	super
#	puts "test  = "+test.inspect	
	email = params[:account][:email]
  @account = Account.find_by_email(email)
	
#	puts @account.inspect if @account != nil
	puts "email = "+email
# fist find the user clone
	@users = User.where("is_active = ? AND clone_email = ?","false",email)
	@user = @users[0] if @users.size > 0
	
	#puts "user = "+@user.inspect
	if(@user == nil)
		#puts "user == nil"
		@account.user = User.new(params[:account][:user])
	else
	#	puts "user != nil"
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
    @account.save

 end
 
 def awaiting_confirmation
   puts "---------->>>>>>>>>>>>> confirm message  <<<<__________________"
   
   @email = Account.find_by_id(params[:format]).get_email
   puts "email " + @email.inspect
   
   render 'awaiting_confirmation'
   return
   
 end
 protected
 def after_inactive_sign_up_path_for(resource)
   puts "UUUUUUUUU kkk  UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
   puts "resource " + resource.inspect
  # @email = resource[:email]
  # @params[:email]= resource[:email]
    
   #account_session[:email] = resource[:email]
    
   awaiting_confirmation_url (resource) 
   #awaiting_confirmation_path (resource)
  
  #root_path
   #'registrations/awaiting_confirmation'
   #render 'awaiting_confirmation'
 #  "http://www.google.com"
 end
  
end  