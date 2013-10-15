class AddMobileToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :mobile,           :string, :limit => 40
  end

  def self.down
    remove_column "contacts", "mobile"
  end
end
