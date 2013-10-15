class AddIsDefaultCalculatorRateToRates < ActiveRecord::Migration
  def self.up
    add_column :rates, :is_default_calculator_rate, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :rates, 'is_default_calculator_rate'
  end
end
