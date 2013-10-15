class NewsletterIssue < ActiveRecord::Base
  belongs_to :newsletter
  
  validates_presence_of     :text, :subject
  
  # Convert text to html using Textile
	def before_save
		self.html = RedCloth.new(self.text).to_html
	end
	
	def schedule_for_sending
	 self.status = SCHEDULED
	end
	
	def unschedule_for_sending
	 self.status = UNSCHEDULED
	end
	
	def sent?
	  return self.status == SENT
	end
end
