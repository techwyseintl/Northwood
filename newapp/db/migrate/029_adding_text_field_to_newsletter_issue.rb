class AddingTextFieldToNewsletterIssue < ActiveRecord::Migration
  def self.up
    add_column :newsletter_issues, :plain_text, :text, :default => '', :null => false
  end

  def self.down
    remove_column "newsletter_issues", "plain_text"
  end
end
