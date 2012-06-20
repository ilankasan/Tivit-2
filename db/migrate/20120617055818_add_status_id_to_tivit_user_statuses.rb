class AddStatusIdToTivitUserStatuses < ActiveRecord::Migration
  def self.up
    add_column :tivit_user_statuses, :status_id, :integer
  end

  def self.down
    remove_column :tivit_user_statuses, :status_id
  end
end
