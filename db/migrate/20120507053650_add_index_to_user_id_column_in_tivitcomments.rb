class AddIndexToUserIdColumnInTivitcomments < ActiveRecord::Migration
  def self.up
        add_index :tivitcomments,  :user_id

  end

  def self.down
  end
end
