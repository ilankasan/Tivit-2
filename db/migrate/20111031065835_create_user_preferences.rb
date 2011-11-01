class CreateUserPreferences < ActiveRecord::Migration
  def self.up
    create_table :user_preferences do |t|
      t.integer :user_id
      t.string :section_name
      t.string :setting_name
      t.string :setting_value

      t.timestamps
    end
    add_index :user_preferences, :user_id
 
  end

  def self.down
    drop_table :user_preferences
  end
end
