class CreateAuthenticationServices < ActiveRecord::Migration
  def self.up
    create_table :authentication_services do |t|
      t.integer :account_id
      t.string :provider
      t.string :uid
      t.string :uname
      t.string :uemail

      t.timestamps
    end
  end

  def self.down
    drop_table :authentication_services
  end
end
