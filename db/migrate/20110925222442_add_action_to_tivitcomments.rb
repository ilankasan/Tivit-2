class AddActionToTivitcomments < ActiveRecord::Migration
  def self.up
    add_column :tivitcomments, :action, :string
  end

  def self.down
    remove_column :tivitcomments, :action
  end
end
