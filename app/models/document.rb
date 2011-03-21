class Document < ActiveRecord::Base
# every document has many  activities it can belong (assumming in the future we can link from one tivit to the same document)  
   has_and_belongs_to_many :activities

	mount_uploader :name, TivitDocUploader 
end
