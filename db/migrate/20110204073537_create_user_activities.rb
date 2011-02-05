class CreateUserActivities < ActiveRecord::Migration
  def self.up
    create_table :user_activities do |t|
      t.integer :activity_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_activities
  end
end
