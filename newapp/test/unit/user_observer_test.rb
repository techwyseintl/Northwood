require File.dirname(__FILE__) + '/../test_helper'

class UserObserverTest < Test::Unit::TestCase
  fixtures :users, :contacts

  def test_html_is_generated_in_before_save
    user = users(:oleg)
    user.webpage_text="h1. Hello\n\nTesting"
    user.save
    assert_equal "<h1>Hello</h1>\n\n\n\t<p>Testing</p>", user.webpage_html
  end
  
  def test_users_contacts_are_unassigned_after_user_is_destroyed
    unassigned_count = Contact.find_all_by_user_id(nil).size
    users(:oleg).destroy
    assert_equal Contact.find_all_by_user_id(nil).size, unassigned_count + 6
  end

  protected
    def create_user(options = {})
      User.create({ :first_name => 'Test', :last_name => 'User', :email => 'test_user@example.com', :password => 'test', :password_confirmation => 'test' }.merge(options))
    end
end
