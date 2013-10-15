# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Tell ActionMailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test


# Include your app's configuration here:
ActionMailer::Base.smtp_settings = {
  :address => "linode4.theworkinggroup.ca",
  :domain => "northwoodmortgage.com",
  :port  => 25,
  :mass_mailing => {
    :address => "linode4.theworkinggroup.ca",
    :domain => "northwoodmortgage.com",
    :port  => 25
  }
}

SYSTEM_EMAIL = 'noreply@northwoodmortgage.com'

SITE_URL = 'localhost:3000'


# The contact form on the Northwood Mortgage Life page will be sent to this address
NORTHWOOD_MORTGAGE_LIFE_ADMIN = {:first_name=>'Joe', :last_name=>'Blow', :email => 'joeblow@workingdata.net'}
REFERRAL_ADMIN = {:first_name=>'Joe', :last_name=>'Blow', :email => 'joeblow@workingdata.net'}
