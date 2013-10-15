class ChangingContactUsContent < ActiveRecord::Migration

  def self.up
    execute 'UPDATE `pages` SET `text` = "<div style=\"float:left; width: 250px;\">\r\nNorthwood Mortgage\r\n\r\n\"info@northwoodmortgage.com\":info@northwoodmortgage.com\r\n\r\n\r\n9050 Yonge Street #501,<br />\r\nRichmond Hill,<br />\r\nOntario<br />\r\nL4C 9S6<br />\r\n</div>\r\n\r\n<div style=\"float:right; width: 250px;\">\r\nPhone: 416-969-8130<br />\r\n1-888-257-8130<br/>\r\n<br/>\r\nFax: 905-889-2237\r\n</div>\r\n\r\n<div class=\"clearfloat\" style=\"margin-bottom: 15px;\"></div>\r\n\r\n!/images/content/map.gif!", `html` = "<div style=\"float:left; width: 250px;\">\nNorthwood Mortgage\n\n	<p><a href=\"info@northwoodmortgage.com\">info@northwoodmortgage.com</a></p>\n\n\n9050 Yonge Street #501,<br />\nRichmond Hill,<br />\nOntario<br />\n<span class=\"caps\">L4C 9S6</span><br />\n</div>\n\n<div style=\"float:right; width: 250px;\">\nPhone: 416-969-8130<br />\n1-888-257-8130<br/>\n<br/>\nFax: 905-889-2237\n</div>\n\n<div class=\"clearfloat\" style=\"margin-bottom: 15px;\"></div>\n\n	<p><img src=\"/images/content/map.gif\" alt=\"\" /></p>" WHERE `name` = "Contact Us";'
  end
  
  def self.down
    
  end

end