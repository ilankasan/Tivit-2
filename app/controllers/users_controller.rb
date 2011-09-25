class UsersController < ApplicationController
  
 before_filter :authenticate, :only => [:allusers, :edit, :update]
 before_filter :correct_user, :only => [:edit, :update]
 before_filter :admin_user,   :only => :destroy
 
  
  
  def show
    @user = User.find(params[:id])
   # @myactivities = @user.activities.paginate(:page => params[:page])
    
    @title = @user.name
  end
  
  
  def allusers
    @title = "All users"
    @users = User.paginate(:page => params[:page])

  end
  
      

  def new
    @user = User.new
    @title = "New User Sign up"
  end
  
  
 def create
 	params[:user][:email] = params[:user][:email].downcase 
	@user = User.find_by_email( params[:user]["email"])
	
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	puts "before testing is active user"
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++"
	
	if (@user == nil) # user does not exist, creating a new user
		@user = User.new(params[:user])
		puts "creatign a new user"
	elsif (@user.is_active == false) # checking is a skeleton on an inactive user exists
	  	puts "Activattin a skeleton"+@user.is_active.inspect
	  	@user.update_attributes(params[:user])
		@user.activate_user
   	else
# user already exists
  	   puts "An active user existsin the system"
	   @title = "Sign up"
	   flash[:failed] = "User with this email already exists!"
	   render 'new'
    end
 puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
 #ilan: need to revisit error handling
  if (@user != nil)
    puts "----------->>>>>>>>>>>>>>>>>>>>>>>>>    saving user"
    @user.save
    puts "->>>>>>>>>>>>>>>  After Saving "   
# sending a welcome email to the new user
	UserMailer.welcome_email(@user).deliver
   	sign_in @user
   	flash[:success] = "Welcome to the Tivity!"
   	redirect_to root_path
  else
  	flash[:failed] = "Failed to create user, try again!"
    @title = "Sign up"
  #  render 'new'
  end
  
 end
 
 def edit
    @user = User.find(params[:id])
    @title = "Edit user"
 end
 
 
 def update
 	puts "----------    update usrs -------------------"
 	puts "----------    update usrs -------------------"
    puts params.inspect
    puts "----------    update usrs -------------------"
   
    @user = User.find(params[:id])
    
#save email address lower case
	time = Time.now()
  	
  		
    params[:user]["email"]       = params[:user]["email"].downcase
    params[:user]["last_signin"] =  time.localtime 
     
    if @user.update_attributes(params[:user])
     
     # @user.profile_image = @profile_image 	
      flash[:success] = "Profile updated."
      
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
 end
 
 
  def destroy
    user1 = User.find(params[:id]).destroy
    flash[:success] = "User "+user1.name+" destroyed."
    redirect_to allusers_path
  end
 
 
  
  private

 
 def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
 end
  
  
  def admin_user
      redirect_to(root_path) unless current_user.admin?
  end
  
end
