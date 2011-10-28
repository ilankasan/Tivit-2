class CreateActivityDocuments < ActiveRecord::Migration
  def self.up
    create_table :activities_documents, :id => false do |t|
      t.integer  :activity_id
      t.integer  :document_id
     

      t.timestamps
    end
  end

  def self.down
    drop_table :activities_documents
  end
end
