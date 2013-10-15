class CreateNewsletterIssues < ActiveRecord::Migration
  def self.up
    create_table :newsletter_issues do |t|
      t.column :newsletter_id,  :integer
      t.column :subject, :string, :default => '', :null => false
      t.column :body, :text, :default => '', :null => false
      t.column :created_at, :datetime, :default => '0000-00-00', :null => false
    end
  end

  def self.down
    drop_table :newsletter_issues
  end
end
