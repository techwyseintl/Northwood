class RelaxingContactNotes < ActiveRecord::Migration
  def self.up
    change_column :contacts, :notes, :text
    change_column :users, :webpage_text, :text
    change_column :rates, :term, :text
    change_column :pages, :text, :text
    change_column :pages, :html, :text
  end

  def self.down
    # ...
  end
end
