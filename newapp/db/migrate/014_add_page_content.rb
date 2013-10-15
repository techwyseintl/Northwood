class AddPageContent < ActiveRecord::Migration
  def self.up
    data = File.open('db/migrate/014_add_page_content.yml', 'r').read
		blocks = YAML.load(data)
		blocks.each { |block|
			Page.create(	:name => block.ivars['attributes']['name'], 
								    :text	=> block.ivars['attributes']['text'],
								    :html	=> block.ivars['attributes']['html']
							)
	    }
  end

  def self.down
  end
end
