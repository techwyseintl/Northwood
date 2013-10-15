# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_newapp_session',
  :secret      => '3d35283e6828680e12654e7e9bd0437b52cf35a414863d3e50d66c82cd0caf01efd06909ede469156d6db163778fd345a43ed4b48f7644645d6037e6ebdc20b5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
