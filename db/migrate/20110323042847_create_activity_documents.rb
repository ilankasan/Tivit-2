class CreateActivityDocuments < ActiveRecord::Migration
  def self.up
    create_table :activity_documents do |t|
      t.integer :activity_id
      t.integer :document_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activity_documents
  end
end
