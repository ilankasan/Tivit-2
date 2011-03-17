class ProfileImagesController < ApplicationController
	def edit

		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"

		puts "Edit Profile Image"
		puts params.inspect
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
		
	    render 'edit_profile_image'
	end
	
	def update
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	    puts " -------  PROFILE IMAGE  UPDATE --------"
	    puts params.inspect
	    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	    
		@user = User.find(params[:id])
		if(@user != nil)
			@profile_image = ProfileImage.new(params[:profile_image])
			@user.profile_image = @profile_image  
		else
			puts "user is Nil!!!!!!!"
		end
		render "users/show.html.erb"
	end
	
end
