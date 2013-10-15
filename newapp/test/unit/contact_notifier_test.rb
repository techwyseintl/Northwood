require File.dirname(__FILE__) + '/../test_helper'

class ContactNotifierTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting
  
  fixtures :contacts, :newsletter_issues

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  def test_pre_approval
    assert_difference ActionMailer::Base.deliveries, :size do
      ContactNotifier::deliver_pre_approval(contacts(:contact_with_one_subscription))
      response = ActionMailer::Base.deliveries.first
      assert_equal "Your Pre-Approval application has been submitted with Northwood Mortgage", response.subject
      assert_match /Dear #{contacts(:contact_with_one_subscription).full_name}/, response.body
    end
  end
  
  def test_existing_pre_approval
    assert_difference ActionMailer::Base.deliveries, :size do
      ContactNotifier::deliver_existing_pre_approval(contacts(:contact_with_one_subscription))
      response = ActionMailer::Base.deliveries.first
      assert_equal "Your Pre-Approval application has been submitted with Northwood Mortgage", response.subject
      assert_match /Dear #{contacts(:contact_with_one_subscription).full_name}/, response.body
    end
  end

  def test_rate_watch_signup
    assert_difference ActionMailer::Base.deliveries, :size do
      ContactNotifier::deliver_rate_watch_signup(contacts(:contact_with_one_subscription))
      response = ActionMailer::Base.deliveries.first
      assert_equal "You have subscribed to the Northwood Mortgage Rate Watch newsletter", response.subject
      assert_match /Dear #{contacts(:contact_with_one_subscription).full_name}/, response.body
    end
  end
 
  def test_newsletter_issue
    assert_difference ActionMailer::Base.deliveries, :size do
      ContactNotifier::deliver_newsletter_issue(contacts(:contact_with_one_subscription), newsletter_issues(:issue_one))
      response = ActionMailer::Base.deliveries.first
      assert_equal newsletter_issues(:issue_one).subject, response.subject
      assert_match /#{newsletter_issues(:issue_one).html}/, response.body
    end
  end
  
  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/contact_notifier/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
