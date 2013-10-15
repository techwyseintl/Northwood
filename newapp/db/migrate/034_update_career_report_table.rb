class UpdateCareerReportTable < ActiveRecord::Migration
  def self.up
    add_column :career_reports, :parent_id, :integer
    add_column :career_reports, :content_type, :string
    add_column :career_reports, :filename, :string    
    add_column :career_reports, :thumbnail, :string 
    add_column :career_reports, :size, :integer
    add_column :career_reports, :width, :integer
    add_column :career_reports, :height, :integer
    remove_column "career_reports", "url"
  end
      
  def self.down
    remove_column "career_reports", "parent_id"
    remove_column "career_reports", "content_type"
    remove_column "career_reports", "filename"
    remove_column "career_reports", "thumbnail"
    remove_column "career_reports", "size"
    remove_column "career_reports", "width"
    remove_column "career_reports", "height"
    add_column :career_reports, :url, :string
  end
end
