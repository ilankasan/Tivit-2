class AddIndexToDueColumnInActivities < ActiveRecord::Migration
  def self.up
    add_index :activities, :due
  end

  def self.down
    remove_index :activities, :column => :due
  end
end
