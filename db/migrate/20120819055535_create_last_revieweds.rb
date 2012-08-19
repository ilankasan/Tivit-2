class CreateLastRevieweds < ActiveRecord::Migration
  def self.up
    create_table :last_revieweds do |t|
      t.integer :user_id
      t.integer :module_id
      t.datetime :when

      t.timestamps
    end
  end

  def self.down
    drop_table :last_revieweds
  end
end
