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
# find if there is a skeleton of the user
	  params[:user][:email] = params[:user][:email].downcase 
	  @user = get_user(params) 
	if @user.save
# sending a welcome email to the new user
	UserMailer.welcome_email(@user).deliver
      sign_in @user
      flash[:success] = "Welcome to the Tivity!"
      #redirect_to @user
#send user to home page after sign up
      #render 'pages/home'
      redirect_to root_path
    else
      @title = "Sign up"
      render 'new'
    end
 end
 
 def edit
    @user = User.find(params[:id])
    @title = "Edit user"
 end
 
 
 def update
 	puts "----------    update usrs -------------------"
 	puts "----------    update usrs -------------------"
   puts "----------    update usrs -------------------"
   puts "----------    update usrs -------------------"
   puts "----------    update usrs -------------------"
   puts "----------    update usrs -------------------"
   puts "----------    update usrs -------------------"
   
    puts params.inspect
    puts "----------    update usrs -------------------"
   
  
   
   
    
    @user = User.find(params[:id])
    
    
 #    @profile_image = ProfileImage.new(params[:profile_image])
  #  flash[:notice] = 'Mugshot was successfully created.'
   # redirect_to mugshot_url(@mugshot)     
  
    
#save email address lower case
    params[:user]["email"] = params[:user]["email"].downcase 
    if @user.update_attributes(params[:user])
     
     # @user.profile_image = @profile_image 	
      flash[:success] = "Profile updated."
      
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
 end
 
 
 #def editprofileimage
 
  #end
 
 
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
