class AddProposedDateToTivitUserStatuses < ActiveRecord::Migration
  def self.up
    add_column :tivit_user_statuses, :proposed_date, :datetime
  end

  def self.down
    remove_column :tivit_user_statuses, :proposed_date
  end
end
