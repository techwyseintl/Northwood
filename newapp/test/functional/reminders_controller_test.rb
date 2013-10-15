require File.dirname(__FILE__) + '/../test_helper'
require 'reminders_controller'

# Re-raise errors caught by the controller.
class RemindersController; def rescue_action(e) raise e end; end

class RemindersControllerTest < Test::Unit::TestCase
  fixtures :reminders, :users, :contacts

  def setup
    @controller = RemindersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as(:oleg)
    @user = users(:oleg)
    @reminder = reminders(:reminder1)
    @contact = contacts(:contact_with_one_subscription)
  end
  
  def test_truth
    assert true
  end

  # def test_index
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:reminders)
  # end
  # 
  # def test_create_valid_reminder
  #   assert_difference Reminder, :count do
  #     post :create, :user_id => @user, :contact_id => @contact, :reminder => {:message => "asdf", 
  #                                                                             "remind_on(1i)"=>"2007", 
  #                                                                             "remind_on(2i)"=>"4", 
  #                                                                             "remind_on(3i)"=>"12"}
  #                                                                           bob @response.body
  #     assert_response :redirect
  #     assert_redirected_to :action => 'index'
  #   end
  # end
  # 
  # def test_create_invalid_reminder
  #   assert_no_difference Reminder, :count do
  #     post :create, :reminder => {:message => "", 
  #                                 "remind_on(1i)"=>"2007", 
  #                                 "remind_on(2i)"=>"4", 
  #                                 "remind_on(3i)"=>"12"}
  #     assert_response :success
  #     assert_template 'new'
  #     assert_select "div#errorExplanation"
  #   end    
  # end
  # 
  # def test_update
  #   put :update, :id => @reminder, :reminder => {:message => "asdf", 
  #                                                 "remind_on(1i)"=>"2007", 
  #                                                 "remind_on(2i)"=>"4", 
  #                                                 "remind_on(3i)"=>"12"}
  #   assert_response :redirect
  #   assert_redirected_to :action => 'index'
  # end
  # 
  # 
  # def test_destroy
  #   assert_nothing_raised { Reminder.find(@reminder) }
  #   assert_difference Reminder, :count, -1 do
  #     delete :destroy, :id => @reminder
  #     assert_response :redirect
  #     assert_redirected_to :action => 'index'
  #   end
  #   assert_raise(ActiveRecord::RecordNotFound) { Reminder.find(@reminder) }
  # end
end
