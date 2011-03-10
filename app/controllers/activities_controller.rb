class ActivitiesController < ApplicationController
  before_filter :authenticate, :only => [:create, :new,:update, :destroy,:show,:accept,:decline]
  before_filter :authorized_user, :only => :destroy

   def create
    
    config.debug("------>>>>> Creating activity")
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    puts params.inspect
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    
#adding a strign representation of due date 
  	params["due"] = convert_date_to_string(params,"due") 
    puts "->>>>>>>>>>> Due date id " +params["due"]
 
#adding activity to current user	
    @activity = current_user.add_my_ativity(params)    
	    
    if (@activity != nil)
		invitees = params["invitees"]	
		
	
#Adding invitees to activity
		if (invitees != nil && invitees.empty? == false)
    		add_activity_participants(invitees, @activity)
    	end     

        config.debug("------>>>>> creating activity" + @activity.name )
        flash[:success] = "tivit " +@activity.name + " created!"
        redirect_to root_path
    else
        config.debug("creating activity failed")
#ilan: not sure why we need the below row 
        @feed_items = []
        render 'pages/home'
    end
  end
  
  def destroy
    @activity.destroy
    redirect_back_or root_path
  end
  
  
  def edit
  
    @activity = Activity.find(params[:id])
    @title = "Edit tivit: " +@activity.name
    
  end
  
  
  def show
    
    puts "----------->>>>>>>>>>> sho show show"  
    puts params.inspect
    puts "----------->>>>>>>>>>>"
    
    @activity = Activity.find(params[:id])
    @activity.update_tivit_status_after_show(current_user)
  	@title = @activity.name
  	
  end
  
  def update
   
    puts "-----------    UPDATE ------llllllllll---------"  
   
    
    @activity = Activity.find(params[:id])   
    
    puts "<<<<<<<<<<<<  Before Inspect  >>>>>>>>>>>"
    
    puts params.inspect
   
      
    params["due"] = convert_date_to_string(params, "due")
   
    
# update task status
	if(params["status"] == "true")
		params["status"] = "Completed"
		time = Time.new
		puts "-------->>>>>>>>>>>>>  Completed TTTTTTTTTT!!!!!!!!!!!!!!!!!!!!!!!!!!!" 
    
		params["completed_at"] = time.localtime 

	else
		params["status"] = "in-progress"
	end
	
	puts "-------->>>>>>>>>>>>>  summary = "+params["summary"] 
    puts "-------->>>>>>>>>>>>>  params = "+params.inspect
    
	if(@activity == nil )
		puts "NilNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"
	end
    if (@activity != nil && @activity.update_attributes(params))
      
      puts " ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
      invitee_emails = params["invitees"]	
      
      update_activity_participants_by_email(invitee_emails, @activity)    
    #  @activity.name 		 = params["name"]
    #  @activity.description  = params["description"]
    #  @activity.status 		 = params["status"]
    #  @activity.completed_at = params["completed_at"]
      #@activity.name 		 = params["name"]
    #  @activity.summary		 = params["sumary"]
      
      #add_activity_participants (invitee_email,@activity)
      @activity.save
	  puts " inspecting activity --------------------"
	  
	  puts @activity.inspect 	    
      flash[:success] = "tivit " + @activity.name + " updated"
      redirect_to @activity
      
    else
   	  flash[:failed] = "Errrorrororororor"
      @title = "Edit activity"
      render 'edit'
    end  
  end
  
  
  
  def change_tivit_status
    
    puts "<<<<<<<<<<<<----------->>>>>>>>>>>"  
    puts params.inspect  
 #ilan: the below can be optimized   
    @activity = Activity.find(params[:id])
    
    status = params["status"]
    @action = status
    if(status.downcase == "i_am_done")
    	@title= "I Am Done!"
    else 
    	@title  = status.capitalize
 
    end
    puts "Activity is " + @activity.name
    puts "Title is " + @title  
   
    render 'tivit_status_change'
      
  end
  
   
  def accept
    
    puts "----------->>>>>>>>>>>"  
    puts "-----------    accepet ---------------"  
    puts "<<<<<<<<<<<<----------->>>>>>>>>>>"  
    puts params.inspect  
    puts "<<<<<<<<<<<<----------->>>>>>>>>>>"  
 
    @activity = Activity.find(params[:id])
    puts "Activity is " + @activity.name  
   
    @activity.update_tivit_user_status_accept(current_user,params["comment"])
    UserMailer.user_tivit_status_change_email(current_user, "Acceped",params["comment"],@activity).deliver
  
	redirect_back_or root_path
  	
  end
  

  def i_am_done
    
    puts "-----------    I AM DONE ---------------"  
    
    @activity = Activity.find(params[:id])
    
    @activity.update_tivit_user_status_i_am_done(current_user,params["comment"])
    UserMailer.user_tivit_status_change_done_email(current_user,params["comment"],@activity).deliver
  
	redirect_back_or root_path
  	
  end




  
 def decline
  	puts "----------->>>>>>>>>>>"  
    puts "-----------    decline ---------------"  
  
    @activity = Activity.find(params[:id])
    @activity.update_tivit_user_status_decline(current_user,params["comment"])
    UserMailer.user_tivit_status_change_email(current_user, "Declined",params["comment"],@activity).deliver
    		   
  	redirect_back_or root_path
  end
  
  
  
  private
  
	    def authorized_user
      @activity = Activity.find(params[:id])
      redirect_to root_path unless current_user
    end
end