class ActivityDocumentsController < ApplicationController
	
	
	def edit
		puts "&&&&&&&&&&&&   ActivityDocuments Controller &&&&&&&&&&&&&&&&"
		puts "&&&&&&&&&&&&           Edit                 &&&&&&&&&&&&&&&&"
		puts "&&&&&&&&&&&&           Edit                 &&&&&&&&&&&&&&&&"
		puts "&&&&&&&&&&&&           Edit                 &&&&&&&&&&&&&&&&"
		
		puts "Upload Document Page"
		puts params.inspect
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
		@activity = Activity.find(params[:activity_id])
		puts "current user"
		puts current_user.inspect
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
		
		puts @activity.inspect
		
		puts "before render!"
	    render 'edit_activity_document'
	end
	
	def update
		puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	    puts " -------  Activity Controller  UPDATE --------"
	 #  puts params.inspect  
	 #  puts params["activity_document"].inspect
	    
		@activity= Activity.find(params[:id])
		
		if(params["activity_document"] == nil || params["activity_document"]["name"] == nil)
	    	render 'edit_profile_image'
	    else
	    #ilan: assumming one file verison only
		    activity_doc  = ActivityDocument.new
		    #activity_doc  = @activity.activity_documents.new
		    #documents     = activity_doc.documents
		    document	  = Document.new				
	    	document.name          = params["activity_document"]["name"]
	    	document.version  	   = "1.0"
	    	document.note     	   = document.name.url
	    	document.document_id   = activity_doc.id
	    	
	    	#@activity.activity_documents = activity_doc  
	    	@activity.activity_documents << activity_doc
	    	activity_doc.documents << document
	    	 
	    	#document.save
	    	@activity.save
	    	  	
		  	flash[:success] = "tivit " + @activity.name + " updated"
	  	end
		puts document.inspect
		puts "_____________________________________________________________________"
		puts "URL          = " + document.name.url # => '/url/to/file.png'
		puts "Current path = " + document.name.current_path # => 'path/to/file.png'else
		puts "_____________________________________________________________________"
		
    	redirect_to @activity
		
	end

	
	
end
