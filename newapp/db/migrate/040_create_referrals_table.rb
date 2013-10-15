class CreateReferralsTable < ActiveRecord::Migration
  def self.up
    create_table "referrals", :force => true do |t|
      t.column :name,            :string
      t.column :email,           :string, :default => "", :null => false
      t.column :address,         :string, :default => "", :null => false
      t.column :phone,           :string, :default => "", :null => false
      t.column :mobile,          :string, :default => "", :null => false
      t.column :fax,             :string, :default => "", :null => false
      t.column :webpage_text,    :text
      t.column :webpage_html,    :text
      t.column :webpage_address, :string
      t.column :created_at,      :datetime
      t.column :updated_at,      :datetime
    end
  end

  def self.down
    drop_table :referrals
  end
end
