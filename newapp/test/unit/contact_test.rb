require File.dirname(__FILE__) + '/../test_helper'

class ContactTest < Test::Unit::TestCase
  fixtures :contacts, :subscriptions

  def test_should_create_contact_with_email
    assert_difference Contact, :count do
      contact = create_contact(:email => 'jack_contact@example.com')
      assert !contact.new_record?, "#{contact.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_email
    assert_no_difference Contact, :count do
      contact = create_contact
      assert contact.errors.on(:email)
    end
  end  
  
  def test_should_require_valid_email
    assert_difference Contact, :count do
      contact = create_contact(:email => 'ja%ck_-.@theworkinggroup.ca')
      assert !contact.new_record?, "#{contact.errors.full_messages.to_sentence}"
    end
    assert_no_difference Contact, :count do
      contact = create_contact(:email => 'jack,@theworkinggroup.ca')
      assert contact.errors.on(:email)
    end
    assert_no_difference Contact, :count do
      contact = create_contact(:email => 'jack@as@theworkinggroup.ca')
      assert contact.errors.on(:email)
    end
    assert_no_difference Contact, :count do
      contact = create_contact(:email => 'Jack@theworkinggroup')
      assert contact.errors.on(:email)
    end
  end
  
  def test_should_add_newsletter_subscriptions
    contact = contacts(:contact_with_no_subscriptions)
    contact.subscribes_to = {"1"=>"1", "2"=>"1"}
    assert_difference contact.subscriptions, :count, 2 do
      contact.save_subscriptions()
    end    
  end

  def test_should_delete_newsletter_subscriptions
    assert_difference Subscription, :count, -1 do
      contacts(:contact_with_one_subscription).destroy
    end
  end
  
  def test_should_update_newsletter_subscriptions
    assert_difference Subscription, :count, 1 do
      contacts(:contact_with_one_subscription).update_attributes(:email => 'jack_contact@example.com', :subscribes_to => {"1"=>"1", "2"=>"1"})
    end    
  end
  
  def test_should_update_attributes_if_not_empty
    contact = contacts(:contact_with_one_subscription)
  
    # Check the initial conditions
    assert contact.mobile.empty?
    assert !contact.email.empty?
    assert_not_equal contact.email, 'jack_contact@example.com'
    
    contact.update_attributes_if_not_empty('email' => 'jack_contact@example.com', 'mobile' => '123 456 7890', 'pre_approval_notes'=>{'test'=>'1,2,3'})

    # Check that only the mobile got updated
    assert_not_equal contact.email, 'jack_contact@example.com'
    assert_equal = contact.email, contacts(:contact_with_one_subscription).email
    assert_not_equal = contact.mobile, contacts(:contact_with_one_subscription).mobile
    
    # Check the notes
    assert_match /--\nPre-Approval Application submitted:\n/, contact.notes
    assert_match /Email: jack_contact@example.com/, contact.notes
    assert_match /Test: 1,2,3/, contact.notes
  end
  
  def test_should_save_new_contact_with_pre_approval_in_notes
    new_contact = Contact.new :pre_approval_notes => pre_approval_notes, 
                          :mobile =>"m", :phone => "h", :fax => "f", :first_name => "f", 
                          :last_name => "l", :address => "a", :email => "qwer2@qwer.com"
    new_contact.save
    contact = Contact.find_by_email("qwer2@qwer.com")
    pre_approval_notes.each do |key, value|
      assert_match "#{key.to_s.split('_').each{|s| s.capitalize!}.join(' ')}: #{value}", contact.notes
    end
  end

  def test_should_save_existing_contact_with_pre_approval_in_notes
    attributes = {:pre_approval_notes => pre_approval_notes, 
                 :mobile =>"m", :phone => "h", :fax => "f", :first_name => "f", 
                 :last_name => "l", :address => "a", :email => "qwer2@qwer.com"}
    contacts(:contact_with_one_subscription).update_attributes_if_not_empty(attributes)

    pre_approval_notes.each do |key, value|
      assert_match "#{key.to_s.split('_').each{|s| s.capitalize!}.join(' ')}: #{value}", contacts(:contact_with_one_subscription).notes
    end
  end
  
  def test_append_to_notes
    contact = contacts(:contact_with_one_subscription)
    contact.append_to_notes('hi')
    assert_match "\n------- #{Time.now.to_s :default} ------\n", contact.notes
    assert_match "---\nhi\n", contact.notes
    contact.append_to_notes('world')
    assert_match "hi\n\n--", contact.notes
    assert_match "---\nworld\n", contact.notes
  end
        
  private
  
  def create_contact(options = {})
    Contact.create({ 
      :first_name => 'Jack', 
      :last_name => 'the Contact'
    }.merge(options))
  end
  
  def pre_approval_notes
    {
      'applicant_total_annual_income' => "qwer",
      'co_applicant_first_name' => "asdf",
      'applicant_purpose_of_loan' => "Purchase",
      'co_applicant_total_anual_income' => "zxcv",
      'applicant_amount_requested' => "wert",
      'co_applicant_type_of_income' => "Commission",
      'co_applicant_last_name' => "sdfg",
      'applicant_type_of_income' => "Salaried"
    }
  end
end