class Document < ActiveRecord::Base
	
	  attr_accessible :note, :version
 
	  mount_uploader :name, TivitDocUploader 

end
