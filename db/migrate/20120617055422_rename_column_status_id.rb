class RenameColumnStatusId < ActiveRecord::Migration
  def self.up
    rename_column :tivit_user_statuses, :status_id, :status_id_str
  end

  def self.down
  end
end
