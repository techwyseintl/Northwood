class AddSentAtToNewsletterIssues < ActiveRecord::Migration
  def self.up
    rename_column :newsletter_issues, :body, :text
    add_column :newsletter_issues, :html, :text, :default => '', :null => false
    add_column :newsletter_issues, :status, :integer, :default => 0, :null => false
    add_column :newsletter_issues, :sent_at, :datetime, :default => '0000-00-00'
  end

  def self.down
    rename_column :newsletter_issues, :text, :body
    remove_column "newsletter_issues", "html"
    remove_column "newsletter_issues", "sent_at"
    remove_column "newsletter_issues", "status"
  end
end
