if ENV['RAILS_ENV'] == 'production'
  Bugsnag.configure do |config|
    config.api_key = ENV['bugsnag']
  end
end
