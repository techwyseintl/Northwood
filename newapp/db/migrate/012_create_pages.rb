class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :name,         :string
      t.column :text,         :string
      t.column :html,    :string
    end
  end

  def self.down
    drop_table :pages
  end
end
