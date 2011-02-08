module UsersHelper

  def gravatar_for(user, options = { :size => 50 })
    
    if (user != nil)
         gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
    :gravatar => options)
    end
  end
  
 #Returnes a user object. If there is an inactive skeleton it activates it. 
 # If no user with that email address exists, it creates a new object 
  def get_user(params)
    
    @user = User.find_by_email( params[:user]["email"])
	if (@user == nil)
		@user = User.new(params[:user])
		puts "creatign a new user"
	
	else
		@user.update_attributes(params[:user])
		puts "updatting skeleton user"
		puts "--------------------------------------"
		puts params.inspect
	end
  	return @user
 end
end