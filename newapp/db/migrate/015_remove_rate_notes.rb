class RemoveRateNotes < ActiveRecord::Migration
  def self.up
    drop_table :rate_notes
  end

  def self.down
    create_table "rate_notes", :force => true do |t|
      t.column "notes", :string
    end
  end
end
