# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.2' unless defined? RAILS_GEM_VERSION

require 'pp' # we need it for pretty print in console. wrong spot to put it? works for me.

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'rubygems'
gem 'RedCloth', '=3.0.4'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]
  # Include your app's configuration here:
  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  config.active_record.observers = :job_candidate_observer, :contact_observer, :user_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# Multiple vulnerabilities in parameter parsing in Action Pack (CVE-2013-0156) 
ActionController::Base.param_parsers.delete(Mime::XML) 

ExceptionNotifier.exception_recipients = %w(sean@theworkinggroup.ca jack@theworkinggroup.ca) 
ExceptionNotifier.sender_address = %("Application Error" <admin@northwoodmortgage.com>) 
ExceptionNotifier.email_prefix = "[Northwoood] "

require 'csv'
Mime::SET << Mime::CSV unless Mime::SET.include?(Mime::CSV)

# Add date formats
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :default => '%B %d, %Y'
)

# User roles
ROLE = [
  REGULAR_USER = 0,
  ADMIN = 1,
  NOTIFIED_ADMIN = 2,
  ADMIN_ONLY = 3
]

# Newsletter issue status
UNSCHEDULED = 0
SCHEDULED = 1
SENT = 2

# require 'action_mailer/ar_mailer'
# ActionMailer::Base.delivery_method = :activerecord

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below
Sass::Plugin.options[:template_location] = RAILS_ROOT + '/app/views/styles'

