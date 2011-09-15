class AddCompletedAtToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :completed_at, :datetime
  end

  def self.down
    remove_column :activities, :completed_at
  end
end
