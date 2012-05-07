class AddIndexToInvitedByColumnInActivities < ActiveRecord::Migration
  def self.up
    add_index :activities, :invited_by
  
  end

  def self.down
  end
end
