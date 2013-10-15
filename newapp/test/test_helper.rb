ENV["RAILS_ENV"] = "test"

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require File.expand_path(File.dirname(__FILE__) + '/helper_testcase')

require 'redgreen'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
  include AuthenticatedTestHelper

  def assert_false(item)
    assert_equal false, item
  end
  
  def assert_not_authorized
    assert_redirected_to login_url
    assert_nil assigns["user"]
  end
  
  # Borrowed from topfunky_power_tools plugin
  def assert_error_on(field, model)
  	assert !model.errors[field.to_sym].nil?, "No validation error on the #{field.to_s} field."
  end
  
  # Borrowed from topfunky_power_tools plugin
  def assert_no_error_on(field, model)
  	assert model.errors[field.to_sym].nil?, "Validation error on #{field.to_s}."
  end
  
  def deny(condition, message=nil)
    assert !condition, message
  end
    
end
