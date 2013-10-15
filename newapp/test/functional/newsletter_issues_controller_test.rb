require File.dirname(__FILE__) + '/../test_helper'
require 'newsletter_issues_controller'

# Re-raise errors caught by the controller.
class NewsletterIssuesController; def rescue_action(e) raise e end; end

class NewsletterIssuesControllerTest < Test::Unit::TestCase
  fixtures :newsletter_issues, :newsletters, :users

  def setup
    @controller = NewsletterIssuesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_scheduling
    login_as :oleg
    get :schedule_for_sending, :id => newsletter_issues(:issue_one).id, :newsletter_id => newsletters(:rate_watch).id
    assert_response :redirect
    assert_equal flash[:notice], 'First issue is now scheduled for sending tonight at midnight. You can still edit it until it has been sent.'
    assert_equal 1, NewsletterIssue.find(newsletter_issues(:issue_one).id).status
  end
 
  def test_unscheduling
    login_as :oleg
    get :unschedule_for_sending, :id => newsletter_issues(:issue_two).id, :newsletter_id => newsletters(:rate_watch).id
    assert_response :redirect
    assert_equal flash[:notice], 'Second issue scheduling is cancelled.'
    assert_equal 0, NewsletterIssue.find(newsletter_issues(:issue_two).id).status
  end
 
end
