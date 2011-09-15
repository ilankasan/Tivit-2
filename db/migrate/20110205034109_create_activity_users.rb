class CreateActivityUsers < ActiveRecord::Migration
  def self.up
      create_table :activities_users, :id => false do |t|
      t.integer :activity_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activity_users
  end
end
