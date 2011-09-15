class Document < ActiveRecord::Base
	
	 
	  belongs_to :activitity_document, :foreign_key => "document_id" 
	  attr_accessible :note, :version
 
	  mount_uploader :name, TivitDocUploader 

end
