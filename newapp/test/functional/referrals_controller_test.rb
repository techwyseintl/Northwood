require File.dirname(__FILE__) + '/../test_helper'
require 'referrals_controller'

# Re-raise errors caught by the controller.
class ReferralsController; def rescue_action(e) raise e end; end

class ReferralsControllerTest < Test::Unit::TestCase
  fixtures :referrals, :users

  def setup
    @controller = ReferralsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_routes
    with_options :controller => 'referrals' do |test|
      test.assert_routing 'admin/referrals',        :action => 'index'
      test.assert_routing 'admin/referrals/1',      :action => 'show', :id => '1'
      test.assert_routing 'admin/referrals/new',    :action => 'new'
      test.assert_routing 'admin/referrals/1;edit', :action => 'edit', :id => '1'
      test.assert_routing "referral/#{referrals(:default_referral).webpage_address}", :action=>'webpage', :path=>["default-referral"]
    end
  end
  
  def test_admin_can_index
    login_as(:oleg)
    assert users(:oleg).is_admin?
    get :index
    assert assigns(:referrals)
    assert_response :success
    assert_template 'index'
    assert_tag :tag => "a", :content => "Edit"
    assert_tag :tag => "a", :content => "Remove"
  end

  def test_agent_cannot_index
    login_as(:jack)
    assert !users(:jack).is_admin?
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
    assert users(:oleg).is_admin?
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_admin_can_create
    login_as(:oleg)
    assert users(:oleg).is_admin?
    assert_difference Referral, :count do
      post :create, :referral => {:name => "New Newsletter"}
      assert_equal assigns(:referral).name, "New Newsletter"
      assert_response :redirect
      assert_redirected_to referrals_path
    end
  end
        
  def test_admin_can_edit
    login_as(:oleg)
    assert users(:oleg).is_admin?
    get :edit, :id => referrals(:default_referral).id
    assert_equal assigns(:referral).id, referrals(:default_referral).id
    assert_response :success
    assert_template 'edit'
  end

  def test_admin_can_update
    login_as(:oleg)
    assert users(:oleg).is_admin?
    put :update, :id => referrals(:default_referral).id, :referral => {:name => "Our changed referral"}
    assert_equal assigns(:referral).name, "Our changed referral"
    assert_response :redirect
    assert_redirected_to referrals_path
  end

  def test_admin_can_destroy
    login_as(:oleg)
    assert users(:oleg).is_admin?
    assert_difference Referral, :count, -1 do
      delete :destroy, :id => referrals(:default_referral).id
      assert_response :redirect
      assert_redirected_to referrals_path
    end
  end
  
  def test_user_can_get_contact_form
    get :webpage, :path=>[referrals(:default_referral).webpage_address]
    assert_response :success
    assert_template 'webpage'
    assert assigns(:referral)
  end
  
  def test_user_can_see_post_contact_form_erros
    assert_no_difference ActionMailer::Base.deliveries, :size do
      post :contact, :id => referrals(:default_referral).id, :contact=>{:first_name=>"", :last_name=>"", :email=>"", :notes=>"", :phone=>""}
      assert_response :success
      assert_template 'webpage'
      assert assigns(:contact).errors.on(:email)
    end
  end

  def test_user_can_post_contact_form
    assert_difference ActionMailer::Base.deliveries, :size do
      post :contact, :id => referrals(:default_referral).id, :contact=>{:first_name=>"Joe", :last_name=>"Blow", :email=>"joeblow@theworkinggroup.ca", :notes=>"testing", :phone=>"123-456-7890"}
      assert_response :redirect
      assert_redirected_to '/'
      assert_equal flash[:notice], 'Thank you. You will be contacted shortly.'
    end
  end
  
end
