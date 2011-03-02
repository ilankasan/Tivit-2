class CreateTivitUserStatuses < ActiveRecord::Migration
  def self.up
    create_table :tivit_user_statuses do |t|
      t.integer :user_id
      t.integer :activity_id
      t.string :status_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tivit_user_statuses
  end
end
