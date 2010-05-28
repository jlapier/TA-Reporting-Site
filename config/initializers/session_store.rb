# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_reporting_site_session',
  :secret      => '88b570d567bf352e75cc9555c8272e8f687441004bbece3e44fd4d9abdf5fe2f14152ca2789d08f361ffb7a948f75ae98423ace26cb769aebbcce6f33ad41390'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
