class RenameHandyToolsToMortgageCalculators < ActiveRecord::Migration
  def self.up
    execute "UPDATE `pages` SET `name` = 'Mortgage Calculators' WHERE name = 'Handy Tools'"
  end

  def self.down
    execute "UPDATE `pages` SET `name` = 'Handy Tools' WHERE name = 'Mortgage Calculators'"
  end
end
