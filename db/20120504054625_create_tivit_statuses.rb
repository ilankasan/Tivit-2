class CreateTivitStatuses < ActiveRecord::Migration
  def self.up
    create_table :tivit_statuses do |t|
      t.integer :status_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :tivit_statuses
  end
end
