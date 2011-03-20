class RemoveAvatarColumnsFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_content_type
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_updated_at
  end

  def self.down
    add_column :users, :avatar_updated_at, :datetime
    add_column :users, :avatar_file_size, :integer
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_name, :string
  end
end
