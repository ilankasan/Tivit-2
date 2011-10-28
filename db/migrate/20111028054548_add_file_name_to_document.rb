class AddFileNameToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :file_name, :string
  end

  def self.down
    remove_column :documents, :file_name
  end
end
