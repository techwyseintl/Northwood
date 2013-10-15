class ReplaceAddresses < ActiveRecord::Migration
  def self.up
    execute "UPDATE users SET address='7676 Woodbine Avenue Suite 300 Markham, ON L3R 2N2'"
  end

  def self.down
  end
end
