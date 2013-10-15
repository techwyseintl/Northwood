class JobCandidate < ActiveRecord::Base
  has_many :requests
  has_many :career_reports, :through => :requests
  
  validates_presence_of     :first_name, :last_name, :email
	validates_format_of       :email, 
	                          :with => /^([\w.%-]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
                            :message => "You have entered an invalid email address." 

  attr_accessor :reports
  
  def full_name
    "#{first_name} #{last_name}"
  end

  # Remove all the current requests for career reports  
  def delete_requests
    self.requests.each {|request| request.destroy}
  end

end