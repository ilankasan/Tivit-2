class AddIndexToCreatedAtColumnInTivitcomments < ActiveRecord::Migration
  def self.up
     add_index :tivitcomments,  :created_at

  end

  def self.down
  end
end
