class UpdatesToPages4 < ActiveRecord::Migration
  def self.up
    execute 'INSERT INTO `pages` (`id`,`name`,`text`,`html`) VALUES ("42","Handy Tools","TODO","<p><span class=\"caps\">TODO</span></p>");'
  end
  
  def self.down
    execute 'DELETE FROM `pages` WHERE id = 42;'
  end
end