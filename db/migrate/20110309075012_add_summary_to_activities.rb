class AddSummaryToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :summary, :text, :limit => 1024
  end

  def self.down
    remove_column :activities, :summary
  end
end
