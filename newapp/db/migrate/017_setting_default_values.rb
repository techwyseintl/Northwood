class SettingDefaultValues < ActiveRecord::Migration
  def self.up
    change_column :users, :email,                 :string, :default => '', :null => false
    change_column :users, :address,               :string, :default => '', :null => false
    change_column :users, :phone,                 :string, :default => '', :null => false
    change_column :users, :mobile,                :string, :default => '', :null => false
    change_column :users, :fax,                   :string, :default => '', :null => false
    change_column :users, :photo,                 :string, :default => '', :null => false
    change_column :users, :job_title,             :string, :default => '', :null => false
    change_column :users, :is_active,             :integer, :default => 0,  :null => false
    change_column :users, :webpage_text,          :text, :default => '', :null => false
    change_column :users, :webpage_address,       :string, :default => '', :null => false
    change_column :users, :role,                  :integer, :default => 0,  :null => false
    change_column :users, :first_name,            :string, :default => '', :null => false
    change_column :users, :last_name,             :string, :default => '', :null => false
    
    change_column :contacts, :address,            :string, :default => '', :null => false
    change_column :contacts, :phone,              :string, :default => '', :null => false
    change_column :contacts, :fax,                :string, :default => '', :null => false
    change_column :contacts, :mobile,             :string, :default => '', :null => false
    change_column :contacts, :email,              :string, :default => '', :null => false
    change_column :contacts, :notes,              :text, :default => '', :null => false
    change_column :contacts, :first_name,         :string, :default => '', :null => false
    change_column :contacts, :last_name,          :string, :default => '', :null => false
    
    change_column :reminders, :message,           :text, :default => '', :null => false
    
    change_column :rates, :rate,                  :string, :default => '', :null => false
    change_column :rates, :term,                  :text, :default => '', :null => false
    
    change_column :pages, :name,                  :string, :default => '', :null => false
    change_column :pages, :text,                  :text, :default => '', :null => false
    change_column :pages, :html,                  :text, :default => '', :null => false
    
    change_column :newsletters, :name,             :string, :default => '', :null => false
    
    change_column :job_candidates, :email,        :string, :default => '', :null => false
    change_column :job_candidates, :first_name,   :string, :default => '', :null => false
    change_column :job_candidates, :last_name,    :string, :default => '', :null => false
     
    change_column :career_reports, :report_name,  :string, :default => '', :null => false
    change_column :career_reports, :report_url,   :string, :default => '', :null => false
    
    
  end
  
  def self.down
    
  end
end