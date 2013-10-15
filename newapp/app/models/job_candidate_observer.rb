class JobCandidateObserver < ActiveRecord::Observer

  def after_create(job_candidate)
    JobCandidateNotifier.deliver_job_candidate_report(job_candidate)
  rescue  Net::SMTPFatalError
    # This exception is thrown if the email domain address is the same as the server
    # TODO - I think you're only getting this problem from development mode, I know
    # for a fact that it works fine on the server in staging mode.
    return false
  end
  
  def after_save(job_candidate)
    job_candidate.delete_requests
    
    if job_candidate.reports
      job_candidate.reports.each do |report_id, mail_it|
        job_candidate.requests << Request.create(:job_candidate_id=>job_candidate.id, :career_report_id=>report_id) if mail_it == 'yes'
      end
    end
  end  
end