class CreateUserPreferences < ActiveRecord::Migration
  def self.up
    create_table :user_preferences, :id => false do |t|
      t.integer :user_id
      t.integer :preference_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_preferences
  end
end
