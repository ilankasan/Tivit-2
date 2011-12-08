class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string  :name
      t.string  :note
      t.string  :version
      t.string  :file_name
      t.integer :document_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
