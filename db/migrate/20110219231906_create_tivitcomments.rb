class CreateTivitcomments < ActiveRecord::Migration
  def self.up
    create_table :tivitcomments do |t|
      t.integer  :user_id
      t.string   :comment, :limit => 1024
      t.string   :action
      t.integer  :activity_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tivitcomments
  end
end
