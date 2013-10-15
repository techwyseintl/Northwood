require File.dirname(__FILE__) + '/../test_helper'
require 'job_candidates_controller'

# Re-raise errors caught by the controller.
class JobCandidatesController; def rescue_action(e) raise e end; end

class JobCandidatesControllerTest < Test::Unit::TestCase
  fixtures :job_candidates, :users

  def setup
    @controller = JobCandidatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as(:oleg)
    @candidate = job_candidates(:first_candidate)
    ActionMailer::Base.deliveries.clear
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:job_candidates)
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:job_candidate)
  end

  def test_show
    get :show, :id => @candidate
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:job_candidate)
    assert assigns(:job_candidate).valid?
  end

  def test_create_valid_candidate
    assert_difference JobCandidate, :count do
      post :create, :job_candidate => {
                                        :first_name => "Cameron", :last_name => 'Booth', :email => 'test@test.com',
                                        :reports => {"1"=>"no", "2"=>"no"}
                                      }
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end
  end
  
  def test_create_invalid_candidate
    assert_no_difference JobCandidate, :count do
      post :create, :job_candidate => {
                                        :first_name => "", :last_name => '', :email => '',
                                        :reports => {"1"=>"no", "1"=>"no"}
                                      }
      assert_response :success
      assert_template 'new'
      assert_select "div#errorExplanation"
    end    
  end

  def test_destroy
    assert_nothing_raised { JobCandidate.find(@candidate) }
    assert_difference JobCandidate, :count, -1 do
      delete :destroy, :id => @candidate
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end
    assert_raise(ActiveRecord::RecordNotFound) { JobCandidate.find(@candidate) }
  end
  
  def test_create_new_agent_notification
    # Job candidate gets this email
    assert_difference ActionMailer::Base.deliveries, :size, 1 do
      assert_difference JobCandidate, :count do
        post :create, :job_candidate => {
                                        :first_name => "Cameron", :last_name => 'Booth', :email => 'test@test.com',
                                        :reports => {"1"=>"no", "2"=>"no"}
                                        }
        assert_equal ActionMailer::Base.deliveries.last.to.join, 'test@test.com'
      end
    end
  end
  
end
