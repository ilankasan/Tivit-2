class ActivityDocument < ActiveRecord::Base
	has_many :documents, :foreign_key => "document_id"
	belongs_to :activity 
end
