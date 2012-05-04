class AddIndexToUserIdColumnInTivitUserStatuses.userId < ActiveRecord::Migration
  def self.up
    add_index :tivit_user_statuses, :user_id
  end

  def self.down
  end
end
