require "#{File.dirname(__FILE__)}/../test_helper"

class AgentPagesTest < ActionController::IntegrationTest
  fixtures :users

  def test_agent_pages_are_accessible
    pages = %w{/mortgage-rates /pre-approval /mortgage-qualifier /payment-calculator
              /land-transfer-tax /mortgage-information /rate-watch-signup}
    pages.push ''
    pages.each do |page|
      path = "/olegk#{page}"
      get path
      assert_response :success, "Failure on page #{path}"
    end
  end
  
  def test_no_errors_if_agent_webpage_address_is_wrong
    pages = %w{/mortgage-rates /pre-approval /mortgage-qualifier /payment-calculator
              /land-transfer-tax /mortgage-information /rate-watch-signup}
    pages.push ''
    pages.each do |page|
      path = "/olegkbadbadbad#{page}"
      get path
      assert_response 404, "Failure on page #{path}"    
    end
  end
end
