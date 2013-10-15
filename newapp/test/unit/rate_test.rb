require File.dirname(__FILE__) + '/../test_helper'

class RateTest < Test::Unit::TestCase
  fixtures :rates

  # Replace this with your real tests.
  def  test_create_read_update_delete
    
    newrate = Rate.new
    newrate.rate = "23.03%"
    newrate.term = "term"
    newrate.is_default_calculator_rate = true
    
    #create
    assert newrate.save

    #read
    myrate = Rate.find(newrate.id)
    assert_equal newrate.term, myrate.term

    #update
    myrate.term = myrate.term.reverse
    assert myrate.save

    #delete
    assert myrate.destroy
        
  end
end