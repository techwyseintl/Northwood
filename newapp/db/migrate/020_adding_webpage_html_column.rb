class AddingWebpageHtmlColumn < ActiveRecord::Migration
  def self.up
    add_column :users, :webpage_html, :text, :default => "", :null => false
  end
  
  def self.down
    remove_column :users, :webpage_html
  end
end