class AddIndexToStatusColumnInActivities < ActiveRecord::Migration
  def self.up
    add_index :activities, :status
  end

  def self.down
  end
end
