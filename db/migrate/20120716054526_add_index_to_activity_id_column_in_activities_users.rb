class AddIndexToActivityIdColumnInActivitiesUsers < ActiveRecord::Migration
  def self.up
    add_index :activities_users, :activity_id

  end

  def self.down
  end
end
