class CreateRateWatchSignups < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.column :job_candidate_id, :integer, :null => false
      t.column :career_report_id, :integer, :null => false
    end
      
    rename_column :career_reports, :report_name, :name
    rename_column :career_reports, :report_url, :url    
  end

  def self.down
    drop_table :requests
    
    rename_column :career_reports, :name, :report_name
    rename_column :career_reports, :url,  :report_url
  end
end
