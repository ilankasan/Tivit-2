class AddIndexToLastReviewed < ActiveRecord::Migration
  def self.up
    add_index :last_revieweds, [ :user_id, :module_id ], :unique => true, :name => 'by_user_module' 
  end

  def self.down
  end
end
