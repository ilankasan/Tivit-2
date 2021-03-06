class TivitcommentsController < ApplicationController
  before_filter :authenticate_account!
  
  def create
 # 	puts ">>>>>>>>>---------    create comment ------------------<<<<<<<<"
  #	puts "param - " +params.inspect
  	comment = params["tivitcomment"][:comment]
  	
    unless (comment == nil || comment.lstrip.empty?) 
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
  # make sure comment is 1024 characters   
      if (comment_without_carriage.size > 1024)
        comment_without_carriage = comment_without_carriage[0,1023]
         
       
      end
  	 params["tivitcomment"][:comment] = comment_without_carriage
  	  #puts "final commetn  is = "  +params["tivitcomment"][:comment].to_s
   
      @comment = @activity.tivitcomments.create(params["tivitcomment"])
      
      puts "sending notification "
    if(@activity.get_owner != current_account.user || @activity.get_parent.get_owner != current_account.user )
      send_to = Array.new
      send_to << @activity.get_owner            if @activity.get_owner               != current_account.user
      send_to << @activity.get_parent.get_owner if @activity.get_parent.get_owner    != current_account.user
      send_to << @activity.get_invited_by       if @activity.get_invited_by          != current_account.user   
       
      puts "sending comment notificaiton "
      comentors = @activity.get_all_tivit_commenters_excluding_user(current_account.user)
      
      send_to = (send_to + comentors).uniq
      
      
      EMAIL_QUEUE << {:email_type => "notify_comment_added_to_tivit", :commenter => current_account.user,:comment =>@comment.comment, :tivit =>@activity,:send_to => send_to}
    
      #notify_comment_added_to_tivit(commenter, comment,activity, send_to)
      
    else
      puts "not sending notificaiton"
    end
      
  end # end unless    
	#respond with Ajax when needed...
  respond_to do |format|
      format.html { redirect_to @activity }
      format.js
      puts "--------------->> after responding to Ajax"
  end
  
  
  end

 
end
  

