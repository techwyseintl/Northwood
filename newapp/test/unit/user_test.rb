require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_should_create_user
    assert_difference User, :count do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_email_on_login
    assert_no_difference User, :count do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_require_password
    assert_no_difference User, :count do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference User, :count do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference User, :count do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin@theworkinggroup.ca', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:email => 'quentin2@otheremail.com')
    assert_equal users(:quentin), User.authenticate('quentin2@otheremail.com', 'passpass')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin@theworkinggroup.ca', 'passpass')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_name_for_header
    assert_equal "My", users(:oleg).name_for_header(users(:oleg))
    assert_equal "Oleg's", users(:oleg).name_for_header(users(:jack))
  end
  
  def test_short_email
    assert_equal 'oleg@thewo...', users(:oleg).short_email
  end
  
  def test_save_new_password
    old_crypt = users(:oleg).crypted_password
    assert_match /[a-z]{6,9}/, users(:oleg).save_new_password
    assert_not_equal users(:oleg).crypted_password, old_crypt
  end
  
  def test_named_user_role
    users(:cameron).role=2
    assert_equal users(:cameron).named_user_role, 'Notified Administrator'
    assert_equal users(:oleg).named_user_role, 'Administrator'
    assert_equal users(:jack).named_user_role, 'Regular User'

  end

  protected
    def create_user(options = {})
      User.create({ :first_name => 'Test', :last_name => 'User', :email => 'test_user@example.com', :password => 'test', :password_confirmation => 'test' }.merge(options))
    end
end
