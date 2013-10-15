class SeoForPages < ActiveRecord::Migration
  def self.up
    create_table "headers", :force => true do |t|
      t.column :path,               :string, :default => "", :null => false                    
      t.column :title,         :string, :default => "", :null => false    
      t.column :keywords,      :string, :default => "", :null => false        
      t.column :description,   :text,   :default => "", :null => false    
    end
  end

  def self.down
    drop_table :headers
  end
end
