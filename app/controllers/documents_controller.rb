class DocumentsController < ApplicationController
	
	before_filter :authenticate_account!

   def show
     
     puts "SSSSSHHOOOOOOWWWWWWWWWWWW"
     puts params.inspect
  end  
   def destroy
    
    puts " ______________________________________"
    puts " DELTE Document "+params.inspect
    doc       = Document.find_by_id(params[:id])
    doc.destroy
    #@activity = doc.activity     
#ilan: Need to send an email notifying all participants the activity and tivit
  #related_tivits = @activity.tivits
   # related_tivits.each do |tivit|
   #   tivit.destroy
   # end 
   # @activity.destroy
   redirect_to :back
   # redirect_back 
    #redirect_to @activity
  end
  
  
	
	def new
    puts "&&&&&&&&&&&&   ActivityDocuments Controller Action = add &&&&&&&&&&&&&&&&"
  
    puts "Upload Document Page"
    puts params.inspect
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    @activity = Activity.find(params[:id])
    
    puts "before render!"
  end
  
	
	
	def edit
		puts "&&&&&&&&&&&&   ActivityDocuments Controller &&&&&&&&&&&&&&&&"
	
		puts "Upload Document Page"
		puts params.inspect
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
		@activity = Activity.find(params[:activity_id])
		puts "current user"
		
		puts @activity.inspect
		
		puts "before render!"
	    render 'edit_activity_document'
	end
	
	def create
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	    puts " -------  Activity Controller  CREATE --------"
	 #  puts params.inspect  
	   puts params.inspect
	   @activity= Activity.find(params[:document][:activity_id])
		
#		if(params["activity_document"] == nil || params["activity_document"]["name"] == nil)
	#    	render 'edit_profile_image'
	 #   else
	    #ilan: assumming one file verison only
		    @document	  = Document.new(params[:document]) 				
	    	@document.name          = params["document"]["name"]
	    	@document.version  	   = "1.0"
	    	#@document.note     	   = @document.name.url if @document.name  
	    	@document.user_id      = current_account.user.id 
	    	@document.file_name    = @document.name.filename
        
        @document.save
	    	@activity.documents << @document
	    	@activity.save
	    	  	
		  	#flash[:success] = "tivit " + @activity.name + " updated"
	  	#end
	  puts "niiiiiiiiiiiiiiiiiiiiiiiiiiiil" if @document ==  nil
		unless @document == nil
		  puts "= document.name is:"
		  puts "_____________________________________________________________________"
    puts "__________dddddddddddddd___________________________________________________________"
    
		if(@document.name == nil)
		  puts "nnniiilllll"
		end
		puts "_____________________________________________________________________"
		puts "URL          = " + @document.name.url # => '/url/to/file.png'
		puts "Current path = " + @document.name.current_path # => 'path/to/file.png'else
		puts "Current path = " + @document.name.filename# => 'path/to/file.png'else
    
		puts "_____________________________________________________________________"
		end
		
		
    redirect_to @activity
		
	end

  
	
	
end
