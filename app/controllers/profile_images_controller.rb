class ProfileImagesController < ApplicationController
	
	before_filter :authenticate_account!
	before_filter :validate_user_access_to_user_profile
 
  
	def edit
		@user = User.find(params[:id])
	    render 'edit_profile_image'
	end
	
	def update
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	    puts " -------  PROFILE IMAGE  UPDATE --------"
	    puts params.inspect
	    
	    puts "&&&&&&&&&&&&&&&&&&&"
	    puts params["user"].inspect
	    
		@user = User.find(params[:id])
		
		
		if(params["user"] == nil || params["user"]["avatar"] == nil)
	    	render 'edit_profile_image'
	   else
	    
		
	    
		#@image = ProfileImage.find_by_user_id(params[:id])
		if(@user.profile_image == nil)
			@user.profile_image = ProfileImage.new
		#	@image.user_id =  params[:id]
			puts "image does not exists"
		else
			   # u.avatar.url # => '/url/to/file.png'
    		puts "image exists"
			
		end
		
		#puts "image exists" + params["user"]["avatar"].inspect
			
		@user.profile_image.avatar =params["user"]["avatar"]
		#@image.avatar = File.open('public/images')
		
		
		 	
		@user.profile_image.save!
		
		
		puts "URL          = " + @user.profile_image.avatar.url # => '/url/to/file.png'
		puts "Current path = " + @user.profile_image.avatar.current_path # => 'path/to/file.png'else
		puts "_____________________________________________________________________"
		
    	#render @user
    	#redirect_to edit_profile_image(@user)
    	render 'edit_profile_image'
		
		#render "users/show.html.erb"
		end
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
	
end
