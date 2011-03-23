class Document < ActiveRecord::Base
	
	  belongs_to :activitity_documents  
	  attr_accessible :note, :version
 
	  mount_uploader :name, TivitDocUploader 

end
