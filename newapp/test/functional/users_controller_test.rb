require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase

  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_forgot_password
    get :forgot_password
    assert_response :success
    assert_template 'forgot_password'
  end
  
  def test_emails_forgotten_password
    assert_difference ActionMailer::Base.deliveries, :size, 1 do
      post :forgot_password, {:user=>{:email => users(:jack).email}}
      assert_response :redirect
      assert_redirected_to :action => 'new'
      assert !flash[:notice].empty? 
      assert !assigns(:user).errors.on(:email)        
    end  
  end
  
  def test_does_not_email_forgotten_password
    assert_no_difference ActionMailer::Base.deliveries, :size do
      post :forgot_password, {:user=>{:email => ''}}
      assert_response :success
      assert_template 'forgot_password'    
      assert assigns(:user).errors.on(:email)
    end   
  end
  
  def test_routing
    with_options :controller => 'users' do |test|
      test.assert_routing 'admin/users',             :action => 'index'
      test.assert_routing 'admin/users/1',      :action => 'show', :id => '1'
      test.assert_routing 'admin/users/new',    :action => 'new'
      test.assert_routing 'admin/users/1;edit', :action => 'edit', :id => '1'
    end
  end
  
  
  # ---------------------------------
  # Testing List / Search functionality
  # ---------------------------------
  def test_list_agents
    login_as :oleg
    get :index
    assert_response :success
    assert_tag :tag => 'div', :content => /Add New Agent/
    assert_tag :tag => 'a', :attributes => {:href => /admin\/users\//}, :ancestor => {:tag => 'table'}
    # checking if 10 agents are displayed + 1 row for headers
    assert_tag :tag => "table", :children => {:count => 11, :only => {:tag => 'tr'}}
  
    get :index, :page => 10
    assert_response :success
    # checking if 10 agents are displayed + 1 row for headers
    assert_tag :tag => "table", :children => {:count => 11, :only => {:tag => 'tr'}}
  end
  
  def test_search_agents
    login_as :oleg
    get :index, :search_string => 'smith'
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 11, :only => {:tag => 'tr'}}
    
    get :index, :search_string => 'smith', :page => '10'
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 2, :only => {:tag => 'tr'}}
    
    get :index, :search_string => 'oleg'
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 2, :only => {:tag => 'tr'}}
    assert_tag :tag => 'tr', :content => /Oleg Khabarov/
    
    get :index, :search_string => 'oleg@theworkinggroup.ca'
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 2, :only => {:tag => 'tr'}}
    assert_tag :tag => 'tr', :content => /Oleg Khabarov/
    
    get :index, :search_string => 'jack'
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 2, :only => {:tag => 'tr'}}
    assert_tag :tag => 'tr', :content => /Jack Neto/
    
    get :index, :search_string => 'jack@theworkinggroup.ca'
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 2, :only => {:tag => 'tr'}}
    assert_tag :tag => 'tr', :content => /Jack Neto/
    
    get :index, :search_string => 'blarggggggg!'
    assert_response :success
    assert_no_tag :tag => "table"
    assert_tag :tag => 'p', :content => /No agents matching your search criteria found. Please try searching again./
  end
  
  def test_list_agents_with_admin_controls
    login_as :oleg
    get :index
    assert_response :success
    assert_tag :tag => 'div', :content => /Add New Agent/
    assert_tag :tag => 'a', :attributes => {:href => /admin\/users\//}, :ancestor => {:tag => 'table'}
  end
  
  
  # ---------------------------------
  # Testing Show functionality
  # ---------------------------------
  
  # def test_regular_users_cannot_see_other_agents
  #   login_as :jack
  #   get :show, :id => users(:jack).id
  #   assert_response :success
  #   get :show, :id => users(:cameron).id
  #   assert_response 403
  # end
  
  def test_admins_can_see_other_agents
    login_as :oleg
    get :show, :id => users(:jack).id
    assert_response :success
  end
  
  # def test_regular_users_cannot_add_new_agent
  #   get :new
  #   assert_response 302
  # end
  # 
  # def test_only_admin_can_add_new_agents
  #   login_as :oleg
  #   get :new
  #   assert_response :success
  # end
  # 
  # 
  # # ---------------------------------
  # # Testing Create functionality
  # # ---------------------------------
  # 
  # def test_create_by_admin
  #   login_as :oleg
  #   assert_difference User, :count do
  #     user = create_user
  #   end
  # end
  # 
  # def test_create_by_regular_user
  #   login_as :jack
  #   assert_no_difference User, :count do
  #     user = create_user
  #   end
  # end
  # 
  # def test_sending_of_welcome_email
  #   login_as :oleg
  #   assert_difference ActionMailer::Base.deliveries, :size, 1 do
  #     post :welcome, :id => users(:jack).id
  #     assert_response :redirect
  #     assert_equal flash[:notice], 'Welcome email has been sent.'
  #   end
  #   
  #   assert_difference ActionMailer::Base.deliveries, :size, 0 do
  #     post :welcome, :id => users(:dominic).id
  #     assert_response :redirect
  #     assert_equal flash[:error], 'Please Activate this Agent before sending welcome email.'
  #   end
  #   
  # end
  # 
  # def test_regular_users_sending_welcome_email
  #   login_as :jack
  #   post :welcome, :id => users(:jack).id
  #   assert_response 403
  # end
  # 
  # 
  # # ---------------------------------
  # # Testing Edit functionality
  # # ---------------------------------
  # 
  # def test_regular_user_can_edit_his_account
  #   login_as(:jack)
  #   get :edit, :id => users(:jack).id
  #   assert_response :success
  #   assert_template 'edit'
  #   assert_not_nil assigns(:user)
  #   assert assigns(:user).valid?
  # end
  # 
  # def test_regular_user_cannot_edit_another_account
  #   login_as(:jack)
  #   get :edit, :id => users(:oleg).id
  #   assert_response 403
  # end
  # 
  # def test_admin_can_edit_another_account
  #   login_as(:oleg)
  #   get :edit, :id => users(:jack).id
  #   assert_response :success
  #   assert_template 'edit'
  #   assert_not_nil assigns(:user)
  #   assert assigns(:user).valid?
  # end
  # 
  # def test_regular_user_can_update_his_account
  #   login_as(:jack)
  #   before = users(:jack).first_name
  #   put :update, :id => users(:jack).id, :user=>{:first_name => "#{users(:jack).first_name}o"}
  #   after = User.find(users(:jack).id).first_name
  #   assert_response :redirect
  #   assert_not_nil assigns(:user)
  #   assert_equal before + 'o', after
  #   assert_equal flash[:notice], 'User was successfully updated.'
  # end
  #   
  # def test_regular_user_cannot_update_another_account
  #   login_as(:jack)
  #   put :update, :id => users(:oleg).id, :user=>{:first_name => "#{users(:oleg).first_name}io"}
  #   assert_response 403
  # end
  # 
  # def test_admin_can_update_another_account
  #   login_as(:oleg)
  #   put :update, :id => users(:jack).id, :user=> {:photo=>"", 
  #                                                 :photo_temp=>"", 
  #                                                 :password_confirmation=>"", 
  #                                                 :first_name=>"Jacko",
  #                                                 :last_name=>"Neto",
  #                                                 :role=>"1", 
  #                                                 :phone=>"416-834-2345", 
  #                                                 :password=>"", 
  #                                                 :email=>"quentin@example.com"}
  #   assert_response :redirect
  #   assert_not_nil assigns(:user)
  #   assert_equal User.find(users(:jack).id).first_name, 'Jacko'
  #   assert_equal flash[:notice], 'User was successfully updated.'
  # end
  # 
  # def test_regular_user_cannot_change_admin_only_fields
  #   login_as(:jack)
  #   put :update, :id => users(:jack).id, :user=> {:role => '2'}
  #   after = User.find(users(:jack).id).role
  #   assert_equal after, users(:jack).role
  #   assert_response :redirect
  #   assert_equal flash[:error], 'You are not allowed to edit this information'
  # end
  # 
  # def test_login_required_on_internal_pages
  #   [:show, :edit, :update, :destroy ].each do |c|
  #     get c, :id => users(:jack).id
  #     assert_response 302
  #   end
  # end


protected
  
  def create_user(options = {})
    post :create, :user => { :first_name => 'Quire', :last_name => 'Junior', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire'}.merge(options)
  end

end
