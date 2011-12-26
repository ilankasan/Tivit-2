class CreateTivitUserStatuses < ActiveRecord::Migration
  def self.up
    create_table :tivit_user_statuses do |t|
      t.integer  :user_id
      t.integer  :activity_id
      t.integer  :assigned_to
      t.string   :status_id
      t.string   :comment
      t.datetime :last_reviewed
      t.datetime :proposed_date
      t.datetime :last_status_change

      t.timestamps
    end
  end

  def self.down
    drop_table :tivit_user_statuses
  end
end
