require File.dirname(__FILE__) + '/../test_helper'
require 'rates_controller'

# Re-raise errors caught by the controller.
class RatesController; def rescue_action(e) raise e end; end

class RatesControllerTest < Test::Unit::TestCase
  fixtures :rates, :users

  def setup
    @controller = RatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as(:oleg)
    @rate = rates(:one)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:rates)
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:rate)
  end

  def test_create_valid_rate
    assert_difference Rate, :count do
      post :create, :rate => {:term => "term", :rate => "2.5%", :is_default_calculator_rate=>true}
      # bob @response.body
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end
  end
  
  def test_create_invalid_report
    assert_no_difference Rate, :count do
      post :create, :rate => {:term => "term", :rate => "2.5", :is_default_calculator_rate=>true}
      assert_response :success
      assert_template 'new'
      assert_select "div#errorExplanation"
    end    
  end

  def test_edit
    get :edit, :id => @rate
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:rate)
    assert assigns(:rate).valid?
  end

  def test_update
    put :update, :id => @rate, :rate => {:term => "term", :rate => "2.5%", :is_default_calculator_rate=>true}
    assert_response :redirect
    assert_redirected_to :action => 'index'
  end

  def test_destroy
    assert_nothing_raised { Rate.find(@rate) }
    assert_difference Rate, :count, -1 do
      delete :destroy, :id => @rate
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end
    assert_raise(ActiveRecord::RecordNotFound) { Rate.find(@rate) }
  end
end