require File.dirname(__FILE__) + '/../test_helper'
require 'content_controller'

# Re-raise errors caught by the controller.
class ContentController; def rescue_action(e) raise e end; end

class ContentControllerTest < Test::Unit::TestCase
  
  
  fixtures :users
  
  
  def setup
    @controller = ContentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionMailer::Base.deliveries.clear
  end

  def test_static_public_pages
    assert true
  end
  
  # ---------------------------------
  # Agent search stuff
  # ---------------------------------
  def test_list_agents
    get :agents, :public_area => true
    assert_response :success
    assert_no_tag :tag => 'div', :content => /Add New Agent/
    assert_no_tag :tag => 'a', :attributes => {:href => /admin\/users\//}, :ancestor => {:tag => 'table'}
  end
  
  def test_search_agents
    get :agents, :search_string => 'smith', :public_area => true
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 11, :only => {:tag => 'tr'}}
    
    get :agents, :search_string => 'smith', :page => '10', :public_area => true
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 2, :only => {:tag => 'tr'}}
    
    get :agents, :search_string => 'oleg', :public_area => true
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 2, :only => {:tag => 'tr'}}
    assert_tag :tag => 'tr', :content => /Oleg Khabarov/
    
    get :agents, :search_string => 'oleg@theworkinggroup.ca', :public_area => true
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 2, :only => {:tag => 'tr'}}
    assert_tag :tag => 'tr', :content => /Oleg Khabarov/
    
    get :agents, :search_string => 'jack', :public_area => true
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 2, :only => {:tag => 'tr'}}
    assert_tag :tag => 'tr', :content => /Jack Neto/
    
    get :agents, :search_string => 'jack@theworkinggroup.ca', :public_area => true
    assert_response :success
    assert_tag :tag => "table", :children => {:count => 2, :only => {:tag => 'tr'}}
    assert_tag :tag => 'tr', :content => /Jack Neto/
    
    get :agents, :search_string => 'blarggggggg!', :public_area => true
    assert_response :success
    assert_no_tag :tag => "table"
    assert_tag :tag => 'p', :content => /No agents matching your search criteria found. Please try searching again./
  end
  
  def test_get_to_contact_request_fails
    get :create_contact_request
    assert_redirected_to "/"
  end
  
  def test_create_global_request_contact
    assert_equal User.notified_admins.size, 2
    
    # 2 notified admins get emails
    assert_difference ActionMailer::Base.deliveries, :size, 2 do
      assert_difference Contact, :count, 1 do
        post :create_contact_request, :contact => {:first_name => 'Bob', :last_name => 'Bobowich', :phone => 'Bananaphone', :email => 'bob@workingdata.net', :notes => 'So I was walking through the forest and then all of the sudden...'}
      end
    end
    # apperantly same guy sending request again...
    assert_difference ActionMailer::Base.deliveries, :size, 2 do
      assert_no_difference Contact, :count do
        post :create_contact_request, :contact => {:first_name => 'Bob', :last_name => 'Bobowich', :phone => 'Bananaphone', :email => 'bob@workingdata.net', :notes => 'Hey... It is me again!'}
        assert !Contact.find(:first, :conditions => 'email = "bob@workingdata.net"').notes[/Hey... It is me again!/].nil?
      end
    end
    
    # same contact from global bucket sends request to a specific agent
    # making sure he gets assigned to that agent
    assert_difference ActionMailer::Base.deliveries, :size, 1 do
      assert_no_difference Contact, :count do
        post :create_contact_request, :contact => {:first_name => 'Bob', :last_name => 'Bobowich', :phone => 'Bananaphone', :email => 'bob@workingdata.net', :notes => 'So I was walking through the forest and then all of the sudden...', :user_id => users(:oleg).id}
        assert_equal users(:oleg).id, Contact.find_by_email('bob@workingdata.net').user_id
      end
    end
    
    
    post :create_contact_request
    assert_redirected_to "/"
    
  end
  
  def test_create_new_agent_request_contact
    # agent gets this email
    assert_difference ActionMailer::Base.deliveries, :size, 1 do
      assert_difference Contact, :count, 1 do
        post :create_contact_request, :contact => {:first_name => 'Bob', :last_name => 'Bobowich', :phone => 'Bananaphone', :email => 'bob@workingdata.net', :notes => 'So I was walking through the forest and then all of the sudden...', :user_id => users(:oleg).id}
        assert_equal ActionMailer::Base.deliveries.last.to.join, users(:oleg).email
      end
    end
    # apperantly same guy sending request again...
    assert_difference ActionMailer::Base.deliveries, :size, 1 do
      assert_no_difference Contact, :count do
        post :create_contact_request, :contact => {:first_name => 'Bob', :last_name => 'Bobowich', :phone => 'Bananaphone', :email => 'bob@workingdata.net', :notes => 'Hey... It is me again!', :user_id => users(:oleg).id}
        assert_equal ActionMailer::Base.deliveries.last.to.join, users(:oleg).email
      end
    end
    
    post :create_contact_request, :contact => {:user_id => users(:oleg).id}
    assert_redirected_to '/' + users(:oleg).webpage_address
  end
  
  def test_create_mortgage_renew_request
    assert_equal User.notified_admins.size, 2
    assert_difference ActionMailer::Base.deliveries, :size, 2 do
      post :create_mortgage_renew_request, :renew => {
        :name           => 'Test Name',
        :email          => 'test@test.test',
        :maturity_date  => 'October 20011'
      }
      assert_response :redirect
      assert_equal 'Thank you. Your enquiry has been forwarded', flash[:notice]
    end
  end
  
end
