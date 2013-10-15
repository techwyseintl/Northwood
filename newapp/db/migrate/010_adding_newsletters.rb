class AddingNewsletters < ActiveRecord::Migration
  def self.up
	Newsletter.create(:name => 'Rate Watch')
	Newsletter.create(:name => 'Our News')
  end

  def self.down
  end
end
