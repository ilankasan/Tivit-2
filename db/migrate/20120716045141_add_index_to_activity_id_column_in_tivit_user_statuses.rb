class AddIndexToActivityIdColumnInTivitUserStatuses < ActiveRecord::Migration
  def self.up
        add_index :tivit_user_statuses, :activity_id

  end

  def self.down
  end
end
