class RemoveStatusIdStrColumnFromTivitUserStatuses < ActiveRecord::Migration
  def self.up
    remove_column :tivit_user_statuses, :status_id_str
  end

  def self.down
  end
end
