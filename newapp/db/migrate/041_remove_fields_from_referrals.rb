class RemoveFieldsFromReferrals < ActiveRecord::Migration
  def self.up
    remove_column :referrals, :address
    remove_column :referrals, :mobile
    remove_column :referrals, :fax
  end

  def self.down
    add_column :referrals, :address, :string, :default => "", :null => false
    add_column :referrals, :mobile,  :string, :default => "", :null => false
    add_column :referrals, :fax,     :string, :default => "", :null => false
  end
end
