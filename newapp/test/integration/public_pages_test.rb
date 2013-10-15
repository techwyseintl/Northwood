require "#{File.dirname(__FILE__)}/../test_helper"

class PublicPagesTest < ActionController::IntegrationTest
  # fixtures :your, :models

  def test_public_pages_are_accessible
    pages = %w{/ /about /best-mortgage-rates /mortgages /agents /pre-approval /testimonials
              /mortgage-calculators/mortgage-qualifier /mortgage-calculators/payment-calculator /mortgage-calculators/land-transfer-tax /careers /northwood-mortgage-life /helpful-client-info /mortgage-information
              /contact}
    pages.each do |page|
      get page
      assert_response :success, "Failure on page #{page}"
    end
  end
end
