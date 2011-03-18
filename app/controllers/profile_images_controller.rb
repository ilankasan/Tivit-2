class ProfileImagesController < ApplicationController
	def edit
	#	puts "Edit Profile Image"
	#	puts params.inspect
	#	puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
		@user = User.find(params[:id])
	    render 'edit_profile_image'
	end
	
	def update
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	    puts " -------  PROFILE IMAGE  UPDATE --------"
	    puts params.inspect
	    
	    puts "&&&&&&&&&&&&&&&&&&&"
	    puts params["user"].inspect
	    
		@user = ProfileImage.find(params[:id])
	    
		@image = ProfileImage.find_by_user_id(params[:id])
		if(@image == nil)
			@image = ProfileImage.new
			@image.user_id =  params[:id]
			puts "image does not exists"
		else
			   # u.avatar.url # => '/url/to/file.png'
    		puts "image exists"
			
		end
		
		puts "image exists" + params["user"]["avatar"].inspect
			
		@image.avatar =params["user"]["avatar"]
		#@image.avatar = File.open('public/images') 	
		@image.save!
		
		puts "_____________________________________________________________________"
		puts "URL          = " + @image.avatar.url # => '/url/to/file.png'
		puts "Current path = " + @image.avatar.current_path # => 'path/to/file.png'else
		puts "_____________________________________________________________________"
		
    	#render @user
    	render 'edit_profile_image'
		#render "users/show.html.erb"
	end
	
end
