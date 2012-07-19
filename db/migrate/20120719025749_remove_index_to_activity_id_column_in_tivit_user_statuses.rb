class RemoveIndexToActivityIdColumnInTivitUserStatuses < ActiveRecord::Migration
  def self.up
    remove_index :tivit_user_statuses, :activity_id

  end

  def self.down
  end
end
