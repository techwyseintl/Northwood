class UpdateAgentFaxes < ActiveRecord::Migration
  def self.up
    execute "UPDATE users SET fax='905-300-4977'"
  end

  def self.down
  end
end
