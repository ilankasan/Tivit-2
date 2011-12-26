class  MyDevise::RegistrationsController < Devise::RegistrationsController
                 
   
 before_filter :authenticate_account!
 
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
    @test = "iii"
    flash[:notice] = "------------------------------------------------------GOT"
  
  # redirect_to 'confirm_message'
 end
 
 def awaiting_confirmation(resource)
   puts "---------->>>>>>>>>>>>> confirm message  <<<<__________________"
   
 end
 
 def after_inactive_sign_up_path_for(resource)
   # confirm_message_path
    puts "UUUUUUUUU kkk  UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
    #confirm_message_url
    puts "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
    #flash[:notice] = "We sent an activation email to your email"
    #super
  #  'confirm_message'
   #return "registrations/awaiting_confirmation"
   #'awaiting_confirmation'
   awaiting_confirmation_path
   #return "awaiting_confirmation"
   #return "http://www.google.com"
    
 end
  
end  