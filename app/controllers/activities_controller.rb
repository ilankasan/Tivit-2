class ActivitiesController < ApplicationController
  before_filter :authenticate_account!
  before_filter :validate_access, :except => [:remove_tivit, :reassign]
  after_filter  :update_view_status,   :only => :show
  #after_filter  :send_email_create_tivit, :only => :create_tivit 
   
  # [Yaniv] This line disables the CSRF protection by rails when "post" is done outside of the controller (in our case my jQuery stuff). It's not recommended
  # but to make this work I need to do something in the code which I need to continue to research
  # See details here: http://stackoverflow.com/questions/3558816/what-does-this-mean-actioncontrollerinvalidauthenticitytoken
  # this solution didn't work for me: http://stackoverflow.com/questions/1245618/rails-invalidauthenticitytoken-for-json-xml-requests
  skip_before_filter :verify_authenticity_token
  
   
   def create

# Create Activity
    if(params[:name] == nil || params[:name].empty?)
      flash[:failed] = "Activity name cannot be empty"
      account_session[:flash_error] = "Activity name cannot be empty"
      redirect_to root_path
      return
    end
  	params["due"] = adjust_date_to_end_of_day(parse_date(params,"due"))
   		
   @activity = current_account.user.add_my_ativity(params)    
	# Adding activity to current user	
        
    if (@activity != nil)
		invitees = params["invitees"]	
	
#Adding invitees to activity
		  if (invitees != nil && invitees.empty? == false)
    		add_activity_participants(invitees, @activity)
# email invitee an email
			#UserMailer.new_tivit_email(user,owner,self).deliver

      end     
        config.debug("------>>>>> creating activity" + @activity.name )
        flash[:success] = @activity.name + " Activity created succesfully!"
#        redirect_to root_path
#redirect_to 'shared/activitydetails'
        render 'show'
                       
    else
        config.debug("creating activity failed")
#ilan: not sure why we need the below row 
        @feed_items = []
        render 'pages/home'
    end
  end
  
  def destroy
   puts "in destroy"
    #puts params.inspect
    @activity = Activity.find(params[:id])
    
  #ilan: Need to send an email notifying all participants the activity and tivit
    related_tivits = @activity.tivits
    related_tivits.each do |tivit|
    tivit.destroy
    end
    docs  = @activity.documents
    docs.each do |doc|
      doc.destroy
    end
    
    @activity.destroy 
    
   redirect_to root_path
  end
  
  
  def edit
  	puts "edit activit"
        @activity = Activity.find(params[:id])
    @title = "Edit tivit: " +@activity.name
  end
  
  def remove_tivit
  	puts "Remove Tivit"
  	@tivit    = Activity.find(params[:id])
  	@activity = @tivit.get_parent
  	@tivit.destroy
  	redirect_to @activity
  end
  
  
  def edit_tivit
      puts "edit tivit"
      puts params.inspect  
    
    @activity = Activity.find(params[:id])
    @title = "Edit tivit: " +@activity.name
    
    respond_to do |format|
       format.html {}
       format.js {}
       puts "[Yaniv] (activities controller)------->> after edit_tivit."
    end    
  end
  
  def show
    
    puts "----------->>>>>>>>>>> show activity detailed page"
    @activity_temp = Activity.find(params[:id])
    if(!@activity_temp.isActivity?)
#this is a tivit
      puts ">>>>>>>>>>>>>>>>>>    this is a tivit <<<<<<<<<<<<<<<<<<<<<<"
      @tivit_id = @activity_temp.id
      @activity = @activity_temp.get_parent
    else
      @activity = @activity_temp
    end
   
   # @activity.update_status_after_show(current_account.user)
    
  	@title = "Activity Details - "+@activity.name
  	puts "<<<<<<<<<<<<<<-----------show activity detailed page"  
   
  end
  
  def update_reviewed
    puts ">>>>>>>>>>>>>>>>>   updating reviewed!!!!!"  
   
    @tivit = Activity.find(params[:id])
    if(@tivit != nil)
        @tivit.update_status_after_show(current_account.user)
        puts "updating reviewed" 
    end  
      
    respond_to do |format|
       format.html { redirect_to @tivit }
       format.js {}
       puts "[Yaniv] (activities controller)------->> after update_reviewed."
    end   
    
  end
   
  def update_view_status
   puts "----------->>>>>>>>>>> update_view_status"
   if(@tivit_id != nil)
    @tivit = Activity.find(params[:id])
    if(@tivit != nil)
        @tivit.update_status_after_show(current_account.user)
        puts "updating reviewed" 
    end  
   end
       
   #@activity.update_status_after_show(current_account.user)
  end
 
 
 def validate_access
    return if(params == nil || params[:id] == nil)
       
    @activity = Activity.find(params[:id])   
   if(!validate_user_access_to_activity(@activity,current_account.user))
      render 'shared/access_denied' 
   end
   
 end
   
  
  def update_tivit
    puts "-----------    UPDATE tivit"  
    puts params.inspect
    @activity = Activity.find(params[:id])   
    
    params["due"] = adjust_date_to_end_of_day(parse_date(params, "due"))
   
    
# checking to see if the tivit was previously closed. This will be used before the email is sent out below
  if (@activity != nil && @activity.update_attributes(params))
   
      flash[:success] = "tivit " + @activity.name + " has been updated"
      redirect_to @activity
      
    else
      if(params[:name] == nil || params[:name].empty?)   
        flash[:failed] = "Failed to update tivit. Name cannot be empty"
      else
        flash[:failed] = "Failed to update tivit"
      end
      redirect_to @activity
    end
  end

  
  def update
   
    puts "-----------    UPDATE ------llllllllll---------"  
    
    @activity = Activity.find(params[:id])   
    
    puts params.inspect
    params["due"] = adjust_date_to_end_of_day(parse_date(params, "due"))
   
    
# update activity status to completed if check box was checked 
  
  if(params["activity_status"] == "true")
    params["activity_status"] = "Completed"
  else
    params["activity_status"] = "in-progress"
  end

    
# vhecking to see if tthe task was previously closed. This will be used before the email is sent out below
  was_completed = @activity.status
  if (@activity != nil && @activity.update_attributes(params))
      #puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" +params["activity_status"]
      
    @activity.update_activity_status(params["activity_status"]) 
 
      invitee_emails = params["invitees"] 
      
#ilan: need to revisit this fucntion. not sure weneed it
      update_activity_participants_by_email(invitee_emails, @activity)
      @activity.save
      
#send email to all parcicipants that tivit was completed (not including owner):
     #if(was_completed != "Completed" && @activity.status == "Completed" )
     if(@activity.status == "Completed" )
     
        notify_users_activity_is_closed(@activity,params["summary"])
     end

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
# need to clean section below
    if(status.downcase == "Done")
    	@title= "I Am Done!"
    else 
    	@title  = status.capitalize
    end
    render 'tivit_status_change'      
  end

   
  def on_it
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   On It   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"  
    @activity = Activity.find(params[:id])
    puts "Activity is " + @activity.name  
    @comment = params["comment"]   
    @activity.update_tivit_user_status_onit(current_account.user,params["comment"])
    log_action_as_comment(@activity,@comment,"OnIt",current_account.user)

  
    #redirect_to  @activity.get_parent
    respond_to do |format|
       format.html { redirect_to @activity  }
       format.js {}
       puts "--------[change status to OnIt activities controller]------->> after responding to Ajax"
     end
    if(current_account.user != @activity.get_invited_by)
# do not send email if the inviter (assigner)is the the assignee  
   #   UserMailer.tivit_status_change_onit_email(current_account.user, params["comment"],@activity).deliver
      EMAIL_QUEUE << {:email_type => "tivit_status_change_onit_email", :assigner => @activity.get_invited_by , :assignee => current_account.user,:comment =>params["comment"], :tivit =>@activity}
      
    end

  end
  
  def new_tivit
  	@activity = Activity.find(params[:id])
    puts "Addign Tivit to Activity " + @activity.name
    render 'new_tivit'   
   
  end
  
  
  def create_tivit
  	puts "--------------->> create Tvit"
  	  
  	due = parse_date(params,"due")
  	
  	puts "due date = "+due.to_s
#adding a strign representation of due date 
  	params["due"] 		= adjust_date_to_end_of_day(due).to_s
  	params["parent_id"] = params[:id] 						#   adding Parent ID
  	params["invited_by"] = current_account.user.id 						#   adding invite by		
	  params["status"]    = "in-progress"
	 
    invitees = params["invitees"]	
   
    # if no invitee provided, assign tivit to current user
    if invitees.empty? 
    #  puts "[Yaniv] invitees is empty!"
      puts "[Yaniv] current_account user email=" + current_account.user.get_email
      @invited_user = current_account.user
    else
      @invited_user = user_by_email(invitees.strip)
    end
    
	  params["owner_id"] =  @invited_user.id
	  params["activity_type"] = "tivit"
	
	  #puts "Inspect Params " +params.inspect
	  
   	
	  current_account.user.addTwoWayContact(@invited_user)
	  params["description"] = clean_comment(params["description"]) 
    @tivit = @invited_user.activities.create(params)
    @tivit.get_parent
    @tivit.update_tivit_user_status_reviewed(current_account.user,"")
    #Change status to on it is tivit assigned to self. Ilan - optimize this section to one function
    if(@invited_user.get_id == current_account.user.get_id)
      @tivit.update_tivit_user_status_onit(current_account.user,"")
    end
    
	  
	  log_action_as_comment(@tivit,params["description"] ,"TivitDetails",current_account.user)
#ilan: the line below is temporary since page assumes the name activity
	 @activity = @tivit    
   #respond with Ajax when needed...
   respond_to do |format|
       format.html { redirect_to root_path }
       format.js
       puts "--------------->> after responding to Ajax"
    end
     if(@invited_user.get_id != current_account.user.get_id)
      EMAIL_QUEUE << {:email_type => "new_tivit_email", :assignee => @invited_user, :assigner => current_account.user,:tivit =>@tivit}
     end
    puts "--------------->> after sending email"
       
  end
  
  def done
    
    @activity = Activity.find(params[:id])
    @activity.update_tivit_user_status_i_am_done(current_account.user,params["comment"])
    @activity.change_status_to_completed (params["comment"])
    log_action_as_comment(@activity,params["comment"],"Done",current_account.user)
    
    respond_to do |format|
       format.html { redirect_to @activity  }
       format.js
       puts "--------[change status to Done activities controller]------->> after responding to Ajax"
    end
    
    if(@activity.isActivity?)
      UserMailer.user_activity_status_change_done_email(current_account.user,params["comment"],@activity).deliver
      puts " is this possible?......NNNNNNNNNNNNNNNNNNNNNNNNNNNNNOOOOOOOOOOOOOOOOOOOOOOOOOOO"
    else
      
      send_to =  @activity.get_all_tivit_commenters_excluding_user(current_account.user)
      send_to << @activity.get_parent.get_owner if (@activity.get_parent.get_owner != current_account.user ) 
      send_to << @activity.get_invited_by       if (@activity.get_invited_by       != current_account.user )
      
      notify_users_tivit_done(send_to.uniq,current_account.user,params["comment"], @activity)
      
    end
    
    #redirect_to  @activity.get_parent
    respond_to do |format|
       format.html { redirect_to @activity  }
       format.js {}
       puts "--------[change status to done! activities controller]------->> after responding to Ajax"
    end
     
  end

  
  def propose_date
    puts "-----------    propose date ---------------" + params["propose_date"]
    
    puts params.inspect  
  	unless (params["propose_date"] == nil)
    	@activity = Activity.find(params[:id])
    	puts "old date = "+@activity.due.inspect
    	puts "new date = "+ params["propose_date"]
    	proposed_date = adjust_date_to_end_of_day(parse_date(params,"propose_date"))
    	@activity.update_tivit_user_propose_date(current_account.user,params["comment"], proposed_date)
    	log_action_as_comment(@activity,params["comment"],"Proposed",current_account.user)
      
      
    	 if(current_account.user != @activity.get_invited_by)
    	   puts "--------------------------- sending email -----------------------------------"
        EMAIL_QUEUE << {:email_type => "tivit_propose_new_date_email", :assigner => @activity.get_invited_by , :assignee => current_account.user,:comment =>params["comment"], :tivit =>@activity}
        #UserMailer.tivit_propose_new_date_email({:assigner => @activity.get_invited_by , :assignee => current_account.user,:comment =>params["comment"], :tivit =>@activity}).deliver
      
       end
    end  
    
    #redirect_to  @activity.get_parent
    respond_to do |format|
       format.html { redirect_to @activity  }
       format.js {}
       puts "--------[change status to propose_date activities controller]------->> after responding to Ajax"
     end
  end

 
  def accept_date
    puts "-----------    Accept Date ---------------"
    @activity = Activity.find(params[:id])
  #  puts    params.inspect
    
    log_action_as_comment(@activity,params["comment"],"Accepted",current_account.user)
    
    puts "Old date = "+ @activity.due.inspect + "   accepted new date  = "+ @activity.get_owner_proposed_date.inspect 
    
    @activity.due = @activity.get_owner_proposed_date+(23.hours+59.minutes)
    @activity.save
    
    @activity.update_tivit_user_status_onit(@activity.get_owner,"")
 #ilan: do i need to change the owner status as accepted? maybe later
 
 # Send an email to the owner of the tivit the the activity owner accepted the proposed date
    UserMailer.tivit_accept_new_date_email(@activity.get_owner,current_account.user , @activity,params["comment"]).deliver
    

    redirect_to @activity.get_parent
  end


 def mark_as_completed
#display page to write activity summary
   puts "-----------    mark_as_completed ---------------"  
   @activity = Activity.find(params[:id])
   render 'activity_compelete_summary' 
 end
 
 
 def completed_activity
#closing an activity

 puts "-----------    completed_activity --------------"  
    
    @activity = Activity.find(params[:id])   
    
    puts params.inspect
    
    if(@activity.change_status_to_completed(params["summary"]))   
#send email to all participants that tivit was completed (not including owner):
      notify_users_activity_is_closed(@activity,params["summary"])
      flash[:success] = "Actvitity " + @activity.name + " successfuly marked as completed"
    else
      flash[:failed] = "Errrorrororororor"
      @title = "Edit activity"
    end
    redirect_to @activity
  end

   
 def decline
    puts "-----------    decline ---------------"  
  
    @activity = Activity.find(params[:id])
    @activity.update_tivit_user_status_decline(current_account.user,params["comment"])
    log_action_as_comment(@activity,params["comment"],"Declined",current_account.user)

    #redirect_to  root_path
    respond_to do |format|
       format.html { redirect_to @activity  }
       format.js
       puts "--------[change status to ** decline ** activities controller]------->> after responding to Ajax"
    end
    
    if(current_account.user != @activity.get_invited_by)
# do not send email if the inviter (assigner)is the the assignee  
        EMAIL_QUEUE << {:email_type => "tivit_decline_email", :assigner => @activity.get_invited_by , :assignee => current_account.user,:comment =>params["comment"], :tivit =>@activity}
    end    	 
 end

 def reassign
    assigned_to = params["assign_to"] 
    puts "---->>> Assining tivit to = "+assigned_to
    # finding if user exists if not creating a clone user
     
    @assigned_user = user_by_email(assigned_to)
    @tivit = Activity.find(params[:id])
    @invited_by    = @tivit.get_invited_by  
    
    if(@assigned_user == nil || @tivit == nil)
      flash[:failed] = "Failed to Reasign tivit"
      #redirect_to root_path if @tivit == nil
      puts "not a user email"
      #redirect_to @tivit if @assined_user == nil   
    else
      puts " Reasign tivit "+@tivit.name
      if (params["comment"] == nil)
        params["comment"] = ""
      end
      
      @tivit.owner_id =  @assigned_user.id
      @tivit.users    << @assigned_user
#ilan need to fix activity model so that invited by will be a relationship
      @tivit.invited_by = current_account.user.get_id  
      current_account.user.addTwoWayContact(@assigned_user)
      @tivit.update_tivit_status_reassiged(current_account.user,params["comment"],@assigned_user)
      
    
      #log_action_as_comment(@tivit,"Re-assigned to "+@assined_user.get_name+": " + params["comment"],"Reassign",current_account.user)
      log_action_as_comment(@tivit,params["comment"],"Reassigned",current_account.user)
      
      puts "sending email"
  #reassign_tivit_old_owner(old_owner, new_owner,assigner, comment,tivit)     
      if(current_account.user != @invited_by)      
          #UserMailer.reassign_tivit_old_owner(current_account.user, @assigned_user, @invited_by, params["comment"], @tivit).deliver
          EMAIL_QUEUE << {:email_type => "reassign_tivit_old_owner", :old_owner => current_account.user, 
                                                                     :new_owner => @assigned_user,
                                                                     :assigner  => @invited_by, 
                                                                     :comment   => params["comment"], 
                                                                     :tivit    =>  @tivit}
          
      
          EMAIL_QUEUE << {:email_type => "reassign_tivit_new_owner", :old_owner => current_account.user, 
                                                                     :new_owner => @assigned_user,
                                                                     :assigner  => @invited_by, 
                                                                     :comment   => params["comment"], 
                                                                     :tivit    =>  @tivit}
                                                                     
        #  UserMailer.reassign_tivit_new_owner(current_account.user, @assigned_user, @invited_by, params["comment"], @tivit).deliver
        #  def reassign_tivit_new_owner(old_owner, new_owner, assigner, comment,  tivit)
      end

      
      flash[:success] = "You successfuly re-assigned tivit to "+@assigned_user.get_name
      @tivit.save
    end
    
  #  puts "[Yaniv] BEFORE REDIRECT TO PARENT"
  
    respond_to do |format|
       format.html { redirect_to @tivit }
       format.js
       puts "--------[*** reassign *** ----->> after responding to Ajax"
    end
  end
   
 def remind
     puts ">>>>>>> -----------    remind ---------------<<<<<<<"  
  
     @activity = Activity.find(params[:id])
# ilan: need to change status to reminded. next version
     @activity.update_tivit_user_status_reminded(@activity.get_owner,params["comment"])
  
    #UserMailer.remind_user_to_review_tivit(current_account.user, params["comment"],@activity).deliver
     EMAIL_QUEUE << {:email_type => "remind_user_to_review_tivit", :assignee => @activity.get_owner ,:user_reminding => current_account.user , :message => params["comment"], :tivit =>@activity}
  	redirect_to  root_path
  end
 
  private
  
	def authorized_user
      @activity = Activity.find(params[:id])
      redirect_to root_path unless current_account.user
    end
end