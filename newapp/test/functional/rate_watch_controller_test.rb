require File.dirname(__FILE__) + '/../test_helper'
require 'rate_watch_controller'

# Re-raise errors caught by the controller.
class RateWatchController; def rescue_action(e) raise e end; end

class RateWatchControllerTest < Test::Unit::TestCase
  
  fixtures :users, :contacts
  
  def setup
    @controller = RateWatchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_rate_watch_subscription
    assert_difference ActionMailer::Base.deliveries, :size, 1 do
      assert_difference Contact, :count, 1 do
        post :create, :contact => {:subscribes_to => {'1' => '1', '2' => '1'}, :first_name => "Bob", :last_name => "Bobo", :email => "bob@workingdata.com"}
        assert_response :redirect
        assert_equal ActionMailer::Base.deliveries.last.to.join, 'bob@workingdata.com'
      end
    end
  end
    
  def test_rate_watch_subscription_to_agent
    assert_difference ActionMailer::Base.deliveries, :size, 1 do
      assert_difference Contact, :count, 1 do
        post :create, :webpage_address => users(:oleg).webpage_address, :contact => {:subscribes_to => {'1' => '1', '2' => '1'}, :first_name => "Jacko", :last_name => "Wacko", :email => "jack@workingdata.com"}
        assert_response :redirect
        assert_equal ActionMailer::Base.deliveries.last.to.join, 'jack@workingdata.com'
        assert_equal Contact.find_by_email('jack@workingdata.com').user_id, users(:oleg).id
      end
    end
  end
  
  
  def test_rate_watch_subscription_of_existing_contact
    assert_difference ActionMailer::Base.deliveries, :size, 1 do
      assert_no_difference Contact, :count do
        post :create, :contact => {:subscribes_to => {'1' => '1', '2' => '1'}, :first_name => "Bob", :last_name => "Bobo", :email => contacts(:agent_smith_contact).email}
        assert_response :redirect
        assert_equal ActionMailer::Base.deliveries.last.to.join, contacts(:agent_smith_contact).email
      end
    end
  end
  
end
