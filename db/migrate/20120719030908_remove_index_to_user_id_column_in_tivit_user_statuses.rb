class RemoveIndexToUserIdColumnInTivitUserStatuses < ActiveRecord::Migration
  def self.up
    remove_index :tivit_user_statuses, :user_id

  end

  def self.down
  end
end
