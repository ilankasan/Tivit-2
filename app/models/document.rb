class Document < ActiveRecord::Base
	
	 
	 # belongs_to :activitity_document, :foreign_key => "document_id"
	 has_and_belongs_to_many :activities 
	  attr_accessible :note, :version, :user_id,:file_name
 
	  mount_uploader :name, TivitDocUploader 
  
end
