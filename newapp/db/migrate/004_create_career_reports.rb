class CreateCareerReports < ActiveRecord::Migration
  def self.up
    create_table "career_reports", :force => true do |t|
      t.column :report_name,  :string
      t.column :report_url,   :string                  
    end
  end

  def self.down
    drop_table "career_reports"
  end
end