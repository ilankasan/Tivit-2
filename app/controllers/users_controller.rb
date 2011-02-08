class UsersController < ApplicationController
  
 before_filter :authenticate, :only => [:allusers, :edit, :update]
 before_filter :correct_user, :only => [:edit, :update]
 before_filter :admin_user,   :only => :destroy
 
  
  
  def show
    @user = User.find(params[:id])
    @myactivities = @user.activities.paginate(:page => params[:page])
    
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
	 
	  @user = get_user(params) 
	if @user.save
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
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
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
