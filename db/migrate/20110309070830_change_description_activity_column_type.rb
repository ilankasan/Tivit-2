class ChangeDescriptionActivityColumnType < ActiveRecord::Migration
  def self.up
  	change_column :activities, :description, :text, :limit => 1024
  	
  end

  def self.down
  	change_column :activities, :description, :string
  	
  end
end
