class AddLastStatusChangeToTivitUserStatuses < ActiveRecord::Migration
  def self.up
    add_column :tivit_user_statuses, :last_status_change, :datetime
  end

  def self.down
    remove_column :tivit_user_statuses, :last_status_change
  end
end
