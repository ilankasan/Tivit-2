 require "rails3-jquery-autocomplete"

class UsersController < ApplicationController
 before_filter :authenticate_account!
 
 prepend_before_filter :validate_access, :except => [:relationship,:autoname]
  
  
 def validate_access
   puts "-------------- tiviti_authenticate_account --------------"
   puts " User is is "+params[:id]
   puts " current user is "+current_account.user.id.to_s
   return if(params == nil || params[:id] == nil)
   if(current_account == nil)
    puts "------>>>>>>>>>>>>>>> current user is NIL!!!!!!"
    return
   end
   if(current_account.user.id.to_s != params[:id])
     puts "Access Denied!"
    
     render 'shared/access_denied' 
   end   
 end
 
  
 # ilan delete autocomplete :user, :email, :extra_data => [:slogan], :display_value => :funky_method
  
 def autoname
# auto completed to get list of users. Nee to expand it to seach name field and names in the user table
#  puts "----------->>>>>>>>>>>>>>>>>  in Auto Name"
 
  if (params[:term] && !current_account.user.mycontacts.nil?)
    like= "%".concat(params[:term].concat("%"))
    clone_emails  = current_account.user.mycontacts.where("clone_email LIKE ? OR name LIKE ? ", like, like)
  #   puts "clone emails = "+clone_emails.inspect
  else
    clone_emails = []
  end

  #list = clone_emails.map {|u| Hash[ :id => u.id, :label => (u.clone_email), :name => u.clone_email]}
  list = clone_emails.map {|u| Hash[ :id => u.id, :label => concat_email_name(u), :name => u.clone_email]}
  render :json => list
end




  def concat_email_name (user)
 #   puts "******************************"
    if (user.account == nil)
        return user.clone_email
    else
       return  user.account.email
    end
  end

  
  def show
    @user = User.find(params[:id])
    @title = "Profile"
  end
  
  
  def allusers
    @title = "All users"
   # @users = User.paginate(:page => params[:page])

  end
  
      
	def new
    @user = User.new
    @title = "Sign up"
  end
  
 def relationship
  @other_user = User.find(params[:id])
  me = current_account.user

  @newTasksForMe       = me.get_new_tasks_assign_to_me  (@other_user) 
  @openTasksForMe      = me.get_open_tasks_assign_to_me (@other_user) 
  @completedTasksForMe = me.get_last_ten_completed_tasks_assign_to_me (@other_user) 
      
     
  @newTasksForOther       = me.get_new_tasks_i_assigned  (@other_user) 
  @openTasksForOther    = me.get_open_tasks_i_assign  (@other_user) 
  @completedTasksForOther = me.get_last_ten_completed_tasks_i_assign (@other_user) 
        

  render "user_relationship"
   
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
 	  puts params.inspect
    puts "----------    update usrs -------------------"
   
    @user = User.find(params[:id])
    
#save email address lower case
	time = Time.now().utc
  	
  	if(params[:user]["email"] != nil)	
    	params[:user]["email"]       = params[:user]["email"].downcase
   end
    	
     
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
    puts "_______________________________________________________"
    puts "_______________________________________________________"
    puts "_______________________________________________________"
   puts "params = "+params.inspect
    user1 = User.find(params[:id])
    puts "!!!>>>>  destoying...tivits for use  "+user1.get_name
    
    if(!(user1.account == nil || user1.account.current_sign_in_at == nil) )
        flash[:failure] = "Cannot delete and active user."
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        return
    end
    puts "--->>> destoying...tivits for use  "+user1.get_name
    tivits = Activity.where(:owner_id => user1.get_id)
    
    tivits.each do |tivit|
      puts "--->>>> destroying tivit "+tivit.name
      tivit.destroy
    end 
    
    
    
    #puts "destoying...tivits for use  "+user1.get_name
    
    #activities
    puts "---***>>>> destoying account"
    if(user1.account != nil)
      user1.account.destroy 
    end
    
    puts "---***>>>> destoying user"
    user1.destroy
    flash[:success] = "User "+user1.name+" destroyed."
    render 'pages/home'

  end
 
 
  
  private
  def validate_user_access_to_user_profile
      @user = User.find(params[:id])
      puts "current_account.user = "+current_account.user.get_id.to_s
      puts "@user = "+@user.get_id.to_s
      
      if(current_account.user != @user)
        render 'shared/access_denied' 
      end
  end
  
  
  def delete_correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_account.user?(@user)
 end
  
  
  def old_admin_user
      redirect_to(root_path) unless current_account.user.admin?
  end
  
end
