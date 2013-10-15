require File.dirname(__FILE__) + '/../test_helper'
require 'pre_approval_application_controller'

# Re-raise errors caught by the controller.
class PreApprovalApplicationController; def rescue_action(e) raise e end; end

class PreApprovalApplicationControllerTest < Test::Unit::TestCase
  
  fixtures :users, :contacts
  
  def setup
    @controller = PreApprovalApplicationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionMailer::Base.deliveries.clear
  end

  def test_view_form
    get :new
    assert_response :success
    assert_not_nil assigns(:contact)
  end
  
  def test_invalid_submission
    post :create, :contact => {}
    assert_response :success
    assert_template 'new'
  end
  
  def test_good_new_contact_submission
    assert_difference Contact, :count do
      assert_difference ActionMailer::Base.deliveries, :size, 3 do # 3 emails... one to user, 2 to notified admins
        post :create, :contact => {:pre_approval_notes => pre_approval_notes,
                                    :mobile =>"m", :phone => "h", :fax => "f", :first_name => "f", 
                                    :last_name => "l", :address => "a", :email => "qwer2@qwer.com"
                                  }
        assert ActionMailer::Base.deliveries.collect(&:to).include?(["qwer2@qwer.com"])
        User.notified_admins.each do |admin|
          assert ActionMailer::Base.deliveries.collect(&:to).include?([admin.email])
        end  
      end
    end
  end
  
  def test_good_existing_contact_submission
    assert_no_difference Contact, :count do
      assert_difference ActionMailer::Base.deliveries, :size, 2 do # 2 emails, to the contact and the agent
        post :create, :contact => {:pre_approval_notes => pre_approval_notes,
                                    :mobile =>"m", :phone => "h", :fax => "f", :first_name => "f", 
                                    :last_name => "l", :address => "a", 
                                    :email => contacts(:contact_with_one_subscription).email
                                  }
        assert ActionMailer::Base.deliveries.collect(&:to).include?([contacts(:contact_with_one_subscription).email])
        assert ActionMailer::Base.deliveries.collect(&:to).include?([contacts(:contact_with_one_subscription).user.email])
      end
    end    
  end
  
  def test_agent_is_notified_if_preapproval_is_on_their_webpage
    post :create, :webpage_address => users(:quentin).webpage_address, :contact => {:pre_approval_notes => pre_approval_notes,
                                :mobile =>"m", :phone => "h", :fax => "f", :first_name => "f", 
                                :last_name => "l", :address => "a", :email => "qwer2@qwer.com"
                              }
    assert_redirected_to "/#{users(:quentin).webpage_address}"
    
    # making sure that contact got assigned/reassigned to this agent
    assert_equal users(:quentin).id, Contact.find_by_email('qwer2@qwer.com').user_id
    
    # Make sure an email is being sent to the agent directly
    assert ActionMailer::Base.deliveries.collect(&:to).include?([users(:quentin).email])
  end
  
private

  def pre_approval_notes
    {
      :applicant_total_annual_income => "qwer",
      :co_applicant_first_name => "asdf",
      :applicant_purpose_of_loan => "Purchase",
      :co_applicant_total_anual_income => "zxcv",
      :applicant_amount_requested => "wert",
      :co_applicant_type_of_income => "Commission",
      :co_applicant_last_name => "sdfg",
      :applicant_type_of_income => "Salaried"
    }
  end
end
