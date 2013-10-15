# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
#require 'smtp_tls'
#

ActionMailer::Base.smtp_settings = {
  :address => "mail2.twg.ca",
  :domain => "northwoodmortgage.com",
  :port  => 25
}

SYSTEM_EMAIL = 'application@northwoodmortgage.com'

SITE_URL = 'http://www.northwoodmortgage.com'


# The contact form on the Northwood Mortgage Life page will be sent to this address
NORTHWOOD_MORTGAGE_LIFE_ADMIN = {:first_name=>'John', :last_name=>'Klotz', :email => 'john.klotz@northwoodmortgage.com'}
REFERRAL_ADMIN = {:first_name=>'Allan', :last_name=>'Kates', :email => 'allan@northwoodmortgage.com'}
