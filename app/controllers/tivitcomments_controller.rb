class TivitcommentsController < ApplicationController
  before_filter :authenticate_account!
  
  def create
  	puts "---------    create comment -----------------------"
  	puts "_________________________________________________________________________________"
  	puts "param - " +params.inspect
  	puts "********************************************"

  	@activity= Activity.find(params[:activity_id])
    
    if (@activity == nil)
			puts "activtity ========= nill !!!!!!!!!!!!!!!!!!!!"
    end

    params["tivitcomment"]["user_id"] = current_account.user.id
    # add action type Note
    params["tivitcomment"]["action"] = "Note"
	
    #		puts "params ----------   " + params["tiviticomment"].inspect 
    @comment = @activity.tivitcomments.create(params["tivitcomment"])
    
    if (@comment != nil)
      puts "@comment =======  " +@comment.inspect
    end
	
	#respond with Ajax when needed...
  respond_to do |format|
      format.html { redirect_to @activity }
      format.js
      puts "--------------->> after responding to Ajax"
  end
  UserMailer.notify_comment_added_to_tivit(current_account.user, @comment,@activity, send_to).deliver
	#redirect_to @activity
	#redirect_to root_path

 end

 
end
  

