class AddDescriptionToSharedFiles < ActiveRecord::Migration
  def self.up
    add_column :shared_files, :description, :text, :default => '', :null => false
  end

  def self.down
    remove_column "shared_files", "description"
  end
end
