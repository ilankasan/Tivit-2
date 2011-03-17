class ProfileImageController < ApplicationController
	def edit

		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"

		puts "Edit Profile Image"
		puts params.inspect
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
		
	    render 'edit_profile_image'
	end
	
	def update
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	    puts " -------   update   --------"
	    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
		$user = User.find(param[:id])
		if(@user != nil)
			@profile_image = ProfileImage.new(params[:profile_image])
			@user.profile_image = @profile_image  
		else
			puts "user is Nil!!!!!!!"
		end
	end
	
end
