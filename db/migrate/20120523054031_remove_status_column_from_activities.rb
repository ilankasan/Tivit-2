class RemoveStatusColumnFromActivities < ActiveRecord::Migration
  def self.up
    remove_column :activities, :status
  end

  def self.down
  end
end
