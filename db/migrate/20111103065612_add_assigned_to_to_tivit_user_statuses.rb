class AddAssignedToToTivitUserStatuses < ActiveRecord::Migration
  def self.up
    add_column :tivit_user_statuses, :assigned_to, :integer
  end

  def self.down
    remove_column :tivit_user_statuses, :assigned_to
  end
end
