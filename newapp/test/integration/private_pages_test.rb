require "#{File.dirname(__FILE__)}/../test_helper"

class PrivatePagesTest < ActionController::IntegrationTest
  fixtures :users, :contacts, :career_reports, :job_candidates, :newsletter_issues, :newsletters,
           :pages, :rates, :reminders, :site_images, :shared_files, :subscriptions

  def test_public_cant_access_admin_pages
    # /shared_files is doing a redirect, not sure why that's needed TODO
    pages = %w{/users /users/1 /users/1/contacts /users/1/contacts/1 
               /contacts /company-contacts /company-contacts/21
               /rates /newsletters /career_reports /job_candidates /pages
               /site_images}
    pages.each do |page|
      path = "/admin#{page}"
      get path
      assert_response 302, "Failure on page #{path}"
    end
  end
end
