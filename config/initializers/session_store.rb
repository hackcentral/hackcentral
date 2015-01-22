# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_hackcentral_session'

#Rails.application.config.session_store :cookie_store, key: '_hackcentral_session', domain: '.hackcentral.co'

#Rails.application.config.session_store :cookie_store, key: '_hackcentral_session', domain: '.hackcentral-production.herokuapp.com'

#Rails.application.config.session_store :cookie_store, key: '_hackcentral_session', domain: '.vcap.me'

# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_hackcentral_session', domain: {
  production: '.hackcentral.co',
  production: '.hackcentral-production.herokuapp.com',
  development: '.vcap.me'
}.fetch(Rails.env.to_sym, :all)