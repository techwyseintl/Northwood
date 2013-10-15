require File.dirname(__FILE__) + '/../test_helper'

class SharedFileTest < Test::Unit::TestCase
  fixtures :shared_files

  def test_short_filename
    assert_equal 'IansFlight.pdf', shared_files(:file_one).short_filename
    assert_equal 'JohnsFlightToZimbabweIsLongAndD...', shared_files(:file_two).short_filename
  end
end
