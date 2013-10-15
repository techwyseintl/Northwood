require File.dirname(__FILE__) + '/../test_helper'
require 'career_reports_controller'

# Re-raise errors caught by the controller.
class CareerReportsController; def rescue_action(e) raise e end; end

class CareerReportsControllerTest < Test::Unit::TestCase
  fixtures :career_reports, :users

  def setup
    @controller = CareerReportsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as(:oleg)
    @report = career_reports(:report_1)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:career_reports)
  end

  def test_should_destroy_career_report
    assert_nothing_raised {
      CareerReport.find(1)
    }
    assert_difference CareerReport, :count, -1 do 
      delete :destroy, :id => 1
      assert_redirected_to career_reports_path
    end
    assert_raise(ActiveRecord::RecordNotFound) {
      CareerReport.find(1)
    }  
  end
end
