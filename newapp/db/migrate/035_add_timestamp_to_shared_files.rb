class AddTimestampToSharedFiles < ActiveRecord::Migration
  def self.up
    add_column :shared_files, :created_at, :datetime
  end

  def self.down
    remove_column "shared_files", "created_at"
  end
end
