class AddStatusIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :status_id, :integer
    
  end

  def self.down
    remove_column :activities, :status_id
  end
end
