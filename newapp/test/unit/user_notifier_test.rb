require File.dirname(__FILE__) + '/../test_helper'
require 'user_notifier'

class UserNotifierTest < Test::Unit::TestCase
  CHARSET = "utf-8"

  include ActionMailer::Quoting
  fixtures :users, :contacts, :reminders, :shared_files
  
  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  
  def test_forgot_password
    user = users(:oleg)
    new_password = user.save_new_password
    response = UserNotifier.create_forgot_password(user, new_password)
    assert_equal "[NORTHWOOD] New password for #{user.full_name}", response.subject
    assert_match /Dear #{user.full_name}/, response.body
    assert_match /You new password is: #{new_password}/, response.body
    assert_equal user.email, response.to[0]
  end

  def test_contact_reminder
    user = users(:oleg)
    contact = user.contacts[0]
    reminder = contact.reminders[0]
    response = UserNotifier.create_contact_reminder(user, reminder)
    assert_equal "[NORTHWOOD] Reminder Re: " + contact.full_name, response.subject
    assert_match /Dear #{user.full_name}/, response.body
    assert_match /Reminder Re: #{contact.full_name}/, response.body
    assert_match /#{reminder.message}/, response.body
    assert_equal user.email, response.to[0]
  end
  
  def test_shared_files_notification
    assert_difference ActionMailer::Base.deliveries, :size do
      response = UserNotifier::deliver_shared_files_notification(users(:jack), SharedFile.find(:all))
      assert_equal "[NORTHWOOD] New files have been uploaded", response.subject
      assert_match /Dear #{users(:jack).full_name}/, response.body
    end
  end

  def test_test_email
    assert_difference ActionMailer::Base.deliveries, :size do
      response = UserNotifier::deliver_test_email(users(:jack).email, 'admin@northwoodmortgage.com')
      assert_equal "[TEST] This is a test email", response.subject
      assert_match /This is a test email./, response.body
    end
  end
end
