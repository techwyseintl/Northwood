class AddFolderToSharedFiles < ActiveRecord::Migration
  def self.up
    add_column :shared_files, :folder, :string
    execute("UPDATE shared_files SET folder = 'main'")
  end

  def self.down
    remove_column :shared_files, :folder
  end
end
