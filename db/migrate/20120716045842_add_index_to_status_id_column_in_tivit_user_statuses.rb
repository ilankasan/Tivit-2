class AddIndexToStatusIdColumnInTivitUserStatuses < ActiveRecord::Migration
  def self.up
    add_index :tivit_user_statuses, :status_id

  end

  def self.down
  end
end
