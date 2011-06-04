class AddCommentToTivitUserStatuses < ActiveRecord::Migration
  def self.up
    add_column :tivit_user_statuses, :comment, :string
  end

  def self.down
    remove_column :tivit_user_statuses, :comment
  end
end
