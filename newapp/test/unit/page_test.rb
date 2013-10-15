require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  fixtures :pages

  def test_create_page_should_run_textile_on_the_text
    page = Page.new :name => 'Page 1', :text => 'This is some text'
    assert page.save
    page = Page.find(page.id)
    assert_equal('<p>This is some text</p>', page.html)
  end
  
  def test_cant_create_2_pages_with_same_name
    page = Page.new :name => 'Page 1', :text => 'This is some text'
    assert page.save
    page2 = Page.new :name => 'Page 1', :text => 'This is some text'
    page2.save
    assert_error_on 'name', page2
  end
end
