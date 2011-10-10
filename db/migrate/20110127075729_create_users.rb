class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :name
      t.string  :clone_email
      t.integer :account_id
      #t.string  :salt
      t.boolean :admin    , :default => false
      t.boolean :is_active, :default => true
      t.timestamps
    end
   # add_index :users, :email, :unique => true
    
  end

  def self.down
    drop_table :users
  end
end
