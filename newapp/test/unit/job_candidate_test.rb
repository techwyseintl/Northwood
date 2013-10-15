require File.dirname(__FILE__) + '/../test_helper'

class JobCandidateTest < Test::Unit::TestCase
  fixtures :job_candidates

  def test_should_create_candidate
    assert_difference JobCandidate, :count do
      candidate = create_candidate(:email => 'jack_candidatet@example.com')
      assert_valid candidate
    end
  end

  def test_should_not_create_candidate_without_email
    assert_no_difference JobCandidate, :count do
      candidate = create_candidate
      assert candidate.errors.on(:email)
    end
  end  

  def test_should_create_candidate_with_requested_career_reports
    assert_difference Request, :count, 2 do
      candidate = create_candidate(:email => 'jack_candidatet@example.com')
    end
  end  

  def test_full_name
    assert_equal job_candidates(:first_candidate).full_name, "Joe Hopeful"
  end

  private
  
    def create_candidate(options = {})
      JobCandidate.create({ 
        :first_name => 'Jack', 
        :last_name => 'the Candidate',
        :reports => {
          "6" => "no",
          "7" => "no",
          "1" => "yes",
          "2" => "yes",
          "3" => "no",
          "4" => "no",
          "5" => "no"
        }
      }.merge(options))
    end      
end
