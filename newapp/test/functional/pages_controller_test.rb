require File.dirname(__FILE__) + '/../test_helper'
require 'pages_controller'

# Re-raise errors caught by the controller.
class PagesController; def rescue_action(e) raise e end; end

class PagesControllerTest < Test::Unit::TestCase
  fixtures :pages, :users

  def setup
    @controller = PagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as(:oleg)
    @page = pages(:home_page)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:pages)
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:page)
  end
  
  def test_create_valid_page
    assert_difference Page, :count do
      post :create, :page => {:name => "new page", :text => "some text"}
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end
  end
  
  def test_create_invalid_page
    assert_no_difference Page, :count do
      post :create, :page => {:name => "", :text => "some text"}
      # bob @response.body
      assert_response :success
      assert_template 'new'
      assert_select "div#errorExplanation"
    end    
  end

  def test_edit
    get :edit, :id => @page
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:page)
    assert assigns(:page).valid?
  end
  
  def test_update
    put :update, :id => @page, :page => {:name => "new page", :text => "some text"}
    assert_response :redirect
    assert_redirected_to :action => 'index'
  end
  
  def test_destroy
    assert_nothing_raised { Page.find(@page) }
    assert_difference Page, :count, -1 do
      delete :destroy, :id => @page
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end
    assert_raise(ActiveRecord::RecordNotFound) { Page.find(@page) }
  end
end
