class AddIndexToActivityIdColumnInTivitcomments < ActiveRecord::Migration
  def self.up
    
    add_index :tivitcomments,  :activity_id

    
  end

  def self.down
  end
end
