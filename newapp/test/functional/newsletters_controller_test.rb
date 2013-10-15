require File.dirname(__FILE__) + '/../test_helper'
require 'newsletters_controller'

# Re-raise errors caught by the controller.
class NewslettersController; def rescue_action(e) raise e end; end

class NewslettersControllerTest < Test::Unit::TestCase
  fixtures :newsletters, :users, :contacts

  def setup
    @controller = NewslettersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @rate_watch = newsletters(:rate_watch)
  end

  def test_admin_can_index
    login_as(:oleg)
    get :index
    assert assigns(:newsletters)
    assert_response :success
    assert_template 'index'
    assert_tag :tag => "a", :content => "Edit"
    assert_tag :tag => "a", :content => "Delete"
  end

  def test_agent_cannot_index
    login_as(:jack)
    get :index
    assert_response 403
  end

  def test_need_login_to_index
    get :index
    assert_response :redirect
    assert_redirected_to login_path
  end

  def test_admin_can_new
    login_as(:oleg)
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_admin_can_create
    login_as(:oleg)
    post :create, :newsletter => {:name => "New Newsletter"}
    assert_equal assigns(:newsletter).name, "New Newsletter"
    assert_response :redirect
    assert_redirected_to newsletters_path
  end
        
  def test_admin_can_edit
    login_as(:oleg)
    get :edit, :id => newsletters(:our_news)
    assert_equal assigns(:newsletter).id, newsletters(:our_news).id
    assert_response :success
    assert_template 'edit'
  end

  def test_cannot_edit_rate_watch
    login_as(:oleg)
    get :edit, :id => newsletters(:rate_watch)
    assert_response :redirect
    assert_redirected_to newsletters_path
  end

  def test_admin_can_update
    login_as(:oleg)
    put :update, :id => newsletters(:our_news), :newsletter => {:name => "Our changed news"}
    assert_equal assigns(:newsletter).name, "Our changed news"
    assert_response :redirect
    assert_redirected_to newsletters_path
  end

  def test_admin_can_destroy
    login_as(:oleg)
    assert_difference Newsletter, :count, -1 do
      delete :destroy, :id => newsletters(:our_news)
      assert_response :redirect
      assert_redirected_to newsletters_path
    end
  end

  def test_contact_can_unsubscribe
    get :confirm_unsubscribe, :id => newsletters(:our_news).id, :email=>contacts(:contact_with_one_subscription)
    assert_response :success
    assert_template 'unsubscribe_newsletter'
  end          
end
