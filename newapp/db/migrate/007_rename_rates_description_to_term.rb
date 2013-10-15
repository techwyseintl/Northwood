class RenameRatesDescriptionToTerm < ActiveRecord::Migration
  def self.up
    rename_column :rates, :description, :term
  end

  def self.down
    rename_column :rates, :term, :description
  end
end
