class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :name
      t.string :description
      t.string :status
      t.datetime :due
      t.datetime :completed_at
      t.integer :owner_id
      t.string :who

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
