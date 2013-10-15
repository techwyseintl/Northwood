class CreateRateNotes < ActiveRecord::Migration
  def self.up
      create_table "rate_notes", :force => true do |t|
        t.column :notes,  :string
      end
  end

  def self.down
      drop_table "rate_notes"
  end
end
