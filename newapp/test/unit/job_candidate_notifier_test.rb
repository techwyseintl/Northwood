require File.dirname(__FILE__) + '/../test_helper'
require 'job_candidate_notifier'

class JobCandidateNotifierTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting
  fixtures :job_candidates, :career_reports
  
  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end
  
  def test_job_candidate_report
    job_candidate = job_candidates(:first_candidate)
    job_candidate.reports = {career_reports(:report_1).id => 'yes', career_reports(:report_2).id => 'no'}
    response = JobCandidateNotifier.create_job_candidate_report(job_candidate)
    assert_equal "Thank you for registering with our Northwood Mortgage", response.subject
    assert_match /Dear #{job_candidate.full_name}/, response.body
    # assert_match /#{career_reports(:report_1).name}/, response.body
    assert_no_match /#{career_reports(:report_2).name}/, response.body
    assert_equal job_candidate.email, response.to[0]
  end
  
  def test_followup_sent
    job_candidate = job_candidates(:first_candidate)
    message = 'testing 1,2,3'
    response = JobCandidateNotifier.create_followup_sent(job_candidate)
    assert_equal "A follow up to your Northwood Mortgage careers inquiry", response.subject
    assert_equal job_candidate.email, response.to[0]
  end
  
  
  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/report_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
