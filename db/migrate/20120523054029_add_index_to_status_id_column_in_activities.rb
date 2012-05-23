class AddIndexToStatusIdColumnInActivities < ActiveRecord::Migration
  def self.up
    add_index :activities, :status_id

  end

  def self.down
  end
end
