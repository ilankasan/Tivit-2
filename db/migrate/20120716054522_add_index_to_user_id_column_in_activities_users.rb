class AddIndexToUserIdColumnInActivitiesUsers < ActiveRecord::Migration
  def self.up
    add_index :activities_users, :user_id

  end

  def self.down
  end
end
