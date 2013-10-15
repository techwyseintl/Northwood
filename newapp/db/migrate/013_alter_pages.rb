class AlterPages < ActiveRecord::Migration
  def self.up
    change_column :pages, :text, :text
    change_column :pages, :html, :text
  end

  def self.down
    change_column :pages, :text, :string
    change_column :pages, :html, :string
  end
end
