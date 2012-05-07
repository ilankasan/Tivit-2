class AddIndexToOwnerIdAndParentIdColumnsInActivities < ActiveRecord::Migration
  def self.up
        add_index :activities, :parent_id
        add_index :activities, :owner_id

  end

  def self.down
  end
end
