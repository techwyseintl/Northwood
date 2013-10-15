class CreateNewslettersAndSubscriptions < ActiveRecord::Migration
  def self.up
    create_table "newsletters", :force => true do |t|
      t.column :name,  :string
    end

    create_table "subscriptions", :force => true do |t|
      t.column :contact_id,  :integer
      t.column :newsletter_id,  :integer
    end
  end

  def self.down
    drop_table "subscriptions"
    drop_table "newsletters"
  end
end
