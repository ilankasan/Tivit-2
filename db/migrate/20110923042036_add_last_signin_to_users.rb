class AddLastSigninToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_signin, :datetime
  end

  def self.down
    remove_column :users, :last_signin
  end
end
