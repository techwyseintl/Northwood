require File.dirname(__FILE__) + '/../../test_helper'

class ApplicationHelperTest < HelperTestCase

  include ApplicationHelper

  fixtures :pages

  def setup
    super
  end
  
  def test_nl2br
    assert_equal "hi<br />world", nl2br("hi\n\rworld")
    assert_equal '',              nl2br('')
  end
  
  def test_header_image
    # assert_match(/\/images\/headers\/small\/header[1-8]\.jpg/, header_image)
    # For the time being can't run this test as I can't figure out how to get params setup
    #@public_area = true
    #@controller.params[:path] = ''
    #assert_match(/\/images\/headers\/large\/header[1-9]\.jpg/, header_image)
  end
  
  def test_value_or_space
    assert_equal '&nbsp;',  value_or_space('')
    assert_equal 'hi',      value_or_space('hi')
  end
  
  def test_display_page
    assert_equal '',                          display_page('asdfasdf')
    assert_equal '<p>This is the home page</p>',  display_page('Home Page')
  end
end
