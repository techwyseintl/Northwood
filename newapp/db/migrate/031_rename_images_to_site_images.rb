class RenameImagesToSiteImages < ActiveRecord::Migration
  def self.up
    rename_table :images, :site_images
  end

  def self.down
    rename_table :site_images, :images
  end
end
