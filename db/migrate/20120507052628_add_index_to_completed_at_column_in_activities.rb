class AddIndexToCompletedAtColumnInActivities < ActiveRecord::Migration
  def self.up
      add_index :activities, :completed_at
  end

  def self.down
  end
end
