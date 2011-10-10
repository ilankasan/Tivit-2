class AddInvitedByToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :invited_by, :integer
  end

  def self.down
    remove_column :activities, :invited_by
  end
end
