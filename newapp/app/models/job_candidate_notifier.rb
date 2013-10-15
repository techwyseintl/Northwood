class JobCandidateNotifier < ActionMailer::Base
  
  include MailerSupport
  
  include ActionController::UrlWriter  
  default_url_options[:host] = SITE_URL
  
  def job_candidate_report(job_candidate)
    setup_email(job_candidate)

    @subject                = "Thank you for registering with our Northwood Mortgage"
    @body["job_candidate"]  = job_candidate
    @body["reports"]        = Array.new
    if job_candidate.reports
      job_candidate.reports.each do |report_id, mail_it|
        @body["reports"] << CareerReport.find(report_id) if mail_it == 'yes'
      end
    end
  end
  
  def followup_sent(job_candidate)
    setup_email(job_candidate)
    #@bcc = NORTHWOOD_CAREERS_ADMIN[:email]
    @subject = "A follow up to your Northwood Mortgage careers inquiry"
  end
end