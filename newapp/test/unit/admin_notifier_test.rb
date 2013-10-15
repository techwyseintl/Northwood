require File.dirname(__FILE__) + '/../test_helper'

class AdminNotifierTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  fixtures :users, :contacts, :referrals

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  def test_contact_request
    assert_difference ActionMailer::Base.deliveries, :size do
      AdminNotifier::deliver_contact_request(users(:oleg), contacts(:contact_with_one_subscription))
      response = ActionMailer::Base.deliveries.first
      assert_equal "[NORTHWOOD] Contact Request", response.subject
      assert_match /Dear #{users(:oleg).full_name}/, response.body
    end
  end
  
  def test_new_contact
    assert_difference ActionMailer::Base.deliveries, :size do
      AdminNotifier::deliver_new_contact(users(:oleg), contacts(:contact_with_one_subscription))
      response = ActionMailer::Base.deliveries.first
      assert_equal "[NORTHWOOD] New Contact", response.subject
      assert_match /Dear #{users(:oleg).full_name}/, response.body
    end
  end
  
  def test_pre_approval
    assert_difference ActionMailer::Base.deliveries, :size do
      AdminNotifier::deliver_pre_approval(users(:oleg), contacts(:contact_with_one_subscription))
      response = ActionMailer::Base.deliveries.first
      assert_equal "[NORTHWOOD] New Pre-Approval Application", response.subject
      assert_match /Dear #{users(:oleg).full_name}/, response.body
    end
  end

  def test_referral_contact_request
    assert_difference ActionMailer::Base.deliveries, :size do
      AdminNotifier::deliver_referral_contact_request(users(:oleg), contacts(:contact_with_one_subscription), referrals(:default_referral))
      response = ActionMailer::Base.deliveries.first
      assert_equal "[NORTHWOOD] Contact Request from a referral: #{referrals(:default_referral).name}", response.subject
      assert_match /Dear #{users(:oleg).full_name}/, response.body
    end
  end
  
  
private
  def read_fixture(action)
    IO.readlines("#{FIXTURES_PATH}/admin_notifier/#{action}")
  end

  def encode(subject)
    quoted_printable(subject, CHARSET)
  end
end
