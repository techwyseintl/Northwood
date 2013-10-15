class Page < ActiveRecord::Base
  validates_presence_of   :name
  validates_uniqueness_of :name
  
  # Convert text to html using Textile
	def before_save
		self.html = RedCloth.new(self.text).to_html
	end
end
