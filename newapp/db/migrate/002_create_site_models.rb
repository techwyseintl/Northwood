class CreateSiteModels < ActiveRecord::Migration
  def self.up
    
    # updating user (agents) table

    add_column :users, :name,             :string
    add_column :users, :address,          :string
    add_column :users, :phone,            :string, :limit => 40
    add_column :users, :mobile,           :string, :limit => 40
    add_column :users, :fax,              :string, :limit => 40
    add_column :users, :photo,            :string
    add_column :users, :job_title,        :string
    add_column :users, :started_on,       :datetime
    add_column :users, :is_active,        :integer
    add_column :users, :webpage_text,     :text
    add_column :users, :webpage_address,  :string
    add_column :users, :role,             :integer
    
    
    create_table "contacts", :force => true do |t|
      t.column :user_id,                  :integer
      t.column :name,                     :string
      t.column :address,                  :string
      t.column :phone,                    :string, :limit => 40
      t.column :fax,                      :string, :limit => 40
      t.column :email,                    :string
      t.column :notes,                    :text
      t.column :created_at,               :datetime
      t.column :updated_at,               :datetime
    end
    
    
    create_table "reminders", :force => true do |t|
      t.column :contact_id,               :integer
      t.column :remind_on,                :datetime
      t.column :message,                  :text
      t.column :created_at,               :datetime
      t.column :updated_at,               :datetime
    end
    
    create_table "rates", :force => true do |t|
      t.column :rate,                     :string
      t.column :description,              :text
      t.column :created_at,               :datetime
      t.column :updated_at,               :datetime
    end
    
    create_table "job_candidates", :force => true do |t|
      t.column :name,                     :string
      t.column :email,                    :string
      t.column :created_at,               :datetime
      t.column :updated_at,               :datetime
    end
    
    add_index :contacts, :user_id
    add_index :reminders, :contact_id
     
  end

  def self.down
    
    remove_column "users", "name"
    remove_column "users", "address"
    remove_column "users", "phone"
    remove_column "users", "mobile"
    remove_column "users", "fax"
    remove_column "users", "photo"
    remove_column "users", "job_title"
    remove_column "users", "started_on"
    remove_column "users", "is_active"
    remove_column "users", "webpage_text"
    remove_column "users", "webpage_address"
    remove_column "users", "role" 
    
    drop_table "contacts"
    drop_table "reminders"
    drop_table "rates"
    drop_table "job_candidates"
  end
end
