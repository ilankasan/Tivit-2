class TivitcommentsController < ApplicationController
  before_filter :authenticate_account!
  
  def create
  	puts ">>>>>>>>>---------    create comment ------------------<<<<<<<<"
  #	puts "param - " +params.inspect
  	comment = params["tivitcomment"][:comment]
  	#puts "commetn length is = "  +comment.length.to_s
  	
  
    comment_without_carriage = comment.gsub(/\r/,"")
    comment_without_carriage = comment_without_carriage.gsub(/\n/," ")
    
    #puts "commetn without carriage = "  +comment_without_carriage
    
  	@activity= Activity.find(params[:activity_id])
    
    if (@activity == nil)
			puts "activtity ========= nill !!!!!!!!!!!!!!!!!!!!"
    end

    params["tivitcomment"]["user_id"] = current_account.user.id
# add action type Note
    params["tivitcomment"]["action"] = "Note"
# make sure comment is 255 characters   
    if (comment_without_carriage.size > 255)
      comment_without_carriage = comment_without_carriage[0,255]
       
     
    end
	 params["tivitcomment"][:comment] = comment_without_carriage
	  #puts "final commetn  is = "  +params["tivitcomment"][:comment].to_s
 
    @comment = @activity.tivitcomments.create(params["tivitcomment"])
    
	#respond with Ajax when needed...
  respond_to do |format|
      format.html { redirect_to @activity }
      format.js
      puts "--------------->> after responding to Ajax"
  end
  
  puts "sending notification "
  if(@activity.get_owner.id != current_account.user.id || @activity.get_parent.get_owner != current_account.user.id )
    send_to = Array.new
    send_to << @activity.get_owner            if @activity.get_owner.id               != current_account.user.id
    send_to << @activity.get_parent.get_owner if @activity.get_parent.get_owner.id    != current_account.user.id
    send_to << @activity.get_invited_by       if @activity.get_invited_by.id          != current_account.user.id   
     
    puts "sending comment notificaiton "
    send_to = send_to + @activity.get_all_tivit_commenters
    UserMailer.notify_comment_added_to_tivit(current_account.user, @comment.comment,@activity, send_to.uniq).deliver
  else
    puts "not sending notificaiton"
  end
	
 end

 
end
  

