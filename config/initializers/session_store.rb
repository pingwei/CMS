# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cms_cloud_session',
  :secret      => 'a2a56c19b4041885a5613b72eb10b86dfd929aa2a741fbaadea5436ee03b0f0b25dd70a5788dbfae241c6638625ba3c292b624e1f42bc70fa06b7ba87a59f795'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
