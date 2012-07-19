class AddIndexToActivityIdActivityIdColumnsInTivitUserStatuses < ActiveRecord::Migration
  def self.up
    add_index :tivit_user_statuses, [ :activity_id, :user_id ], :unique => true, :name => 'by_user_activity' 
 
  end

  def self.down
  end
end
