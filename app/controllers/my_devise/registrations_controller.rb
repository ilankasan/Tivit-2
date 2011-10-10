class  MyDevise::RegistrationsController < Devise::RegistrationsController
   
 before_filter :authenticate_account!
 
  def new
  	puts " new ++++++++++++ registration ++++++++++++++++++++++++++++++++++++++"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	
  	puts "NNNNEEEEEEEEEEEEEEEEWWWWWWWWWWWWWWWWWWWWW"
	puts params.inspect
	
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
 	puts "In Regitration Creat Controller"
 	puts " Params "+params.inspect
	super	
	email = params[:account][:email]
    @account = Account.find_by_email(email)
	
	puts @account.inspect if @account != nil
	puts "email = "+email
# fist find the user clone
	@users = User.where("is_active = false AND clone_email = ?",email)
	@user = @users[0] if @users.size > 0
	
	puts "user = "+@user.inspect
	if(@user == nil)
		puts "user == nil"
		@account.user = User.new(params[:account][:user])
	else
		puts "user != nil"
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
    @account.save
 end
 
end  