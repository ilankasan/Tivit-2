class AddParentIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :parent_id, :integer
  end

  def self.down
    remove_column :activities, :parent_id
  end
end
