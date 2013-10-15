require File.dirname(__FILE__) + '/../test_helper'

class NewsletterTest < Test::Unit::TestCase
  fixtures :newsletters, :subscriptions, :newsletter_issues

  def test_newsletter_one_cant_be_edited
    deny    Newsletter.find(1).can_be_edited?
    assert  Newsletter.find(2).can_be_edited?
  end
  
  def test_subscriptions_and_issues_are_deleted_on_destroy
    assert_difference NewsletterIssue, :count, -2 do
      assert_difference Subscription, :count, -1 do
        Newsletter.find(1).destroy
      end
    end
  end
end
