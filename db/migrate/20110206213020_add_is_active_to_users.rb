class AddIsActiveToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_active, :boolean, :default => true
  end

  def self.down
    remove_column :users, :is_active
  end
end
