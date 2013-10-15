require File.dirname(__FILE__) + '/../test_helper'
require 'shared_files_controller'

# Re-raise errors caught by the controller.
class SharedFilesController; def rescue_action(e) raise e end; end

class SharedFilesControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = SharedFilesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_list_for_admin
    login_as :oleg
    get :index
    assert_response :success 
  end
  
  def test_should_list_for_agent
    login_as :jack
    get :index
    assert_response :success 
  end
  
  def test_should_not_list_if_not_logged_in
    get :index
    assert_response :redirect
    assert_redirected_to :controller => 'sessions', :action => 'new' 
  end    
end
