class UsersController < ApplicationController
  
 before_filter :authenticate, :only => [:allusers, :edit, :update]
 before_filter :correct_user, :only => [:edit, :update]
 before_filter :admin_user,   :only => :destroy
 
  
  
  def show
    @user = User.find(params[:id])
    @myactivities = @user.myactivities.paginate(:page => params[:page])
    
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
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
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
