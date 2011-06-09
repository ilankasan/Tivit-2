class TivitcommentsController < ApplicationController
  #before_filter :authenticate, :only => [:create, :new,:update, :destroy]
  #before_filter :authorized_user, :only => :destroy

  def create
  	puts "---------    create comment -----------------------"
  	puts "********************************************"
  	puts "param - " +params.inspect
  	puts "********************************************"
<<<<<<< HEAD
  	

=======
  	puts "********************************************"
  
>>>>>>> V2.0
  	@activity= Activity.find(params[:activity_id])
  	if (@activity == nil)
			puts "activtity ========= nill !!!!!!!!!!!!!!!!!!!!"
	end

	params["tivitcomment"]["user_id"] = current_user.id
	
#		puts "params ----------   " + params["tiviticomment"].inspect 
	@comment = @activity.tivitcomments.create(params["tivitcomment"])
    if (@comment != nil)
			puts "@comment =======  " +@comment.inspect
	end
	redirect_to @activity
	#redirect_to root_path
  end




# not in use
  def edit
	if(params == nil)
		puts "param is nill !!!!!!!!!!!!!!!!!!!!"
	else	
		puts "param - " +params.inspect
	end
	puts "------------------------- edit new comment ----------------------  " 
  	
  	@activity = Activity.find(params[:id])
    @title = "Add new comment to "+@activity.name
    
	puts "------------->>>>>>>>>>> " + @activity.name 

  end
  

end
