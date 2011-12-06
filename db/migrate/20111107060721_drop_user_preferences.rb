class DropUserPreferences < ActiveRecord::Migration
  def self.up
    drop_table :user_preferences
    end
  end

  def self.down
    drop_table :user_preferences
  end
end
