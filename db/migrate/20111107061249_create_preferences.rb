class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.string :preference

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
