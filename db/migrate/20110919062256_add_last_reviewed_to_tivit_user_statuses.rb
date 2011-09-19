class AddLastReviewedToTivitUserStatuses < ActiveRecord::Migration
  def self.up
    add_column :tivit_user_statuses, :last_reviewed, :datetime
  end

  def self.down
    remove_column :tivit_user_statuses, :last_reviewed
  end
end
