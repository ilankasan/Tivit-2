class AddSummaryToActivities < ActiveRecord::Migration
  def self.up
  #  add_column :activities, :summary, :text, :limit => 1024
   add_column :activities, :summary, :text
  end

  def self.down
    remove_column :activities, :summary
  end
end
