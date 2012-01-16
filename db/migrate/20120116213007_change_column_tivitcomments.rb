class ChangeColumnTivitcomments < ActiveRecord::Migration
  def self.up
    #change_table :tiviticomments do |t|
    #t.change :comment :varchar(1024)
      change_column :tivitcomments, :comment, :string, :limit => 1024
  end


  def self.down
  end
end
