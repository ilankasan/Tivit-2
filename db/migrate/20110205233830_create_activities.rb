class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string   :name
      t.text     :description
      t.string   :status
      t.datetime :due
      t.datetime :completed_at
      t.integer  :owner_id
      t.integer  :parent_id
      t.integer  :invited_by
      t.string   :activity_type
      t.text     :summary

      t.timestamps
    end
     add_index :activities, :due
   
  end

  def self.down
    drop_table :activities
  end
end
