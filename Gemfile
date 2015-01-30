source 'https://rubygems.org'

# Rails Dependencies
gem 'rails', '4.2.0'
gem 'sass-rails', '5.0.1'
gem 'uglifier', '2.7.0'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.3'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development

# HC Dependencies
gem 'paperclip'
gem 'aws-sdk'
gem 'figaro'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'devise'
gem 'doorkeeper'
gem 'friendly_id'
gem 'local_time'
gem 'will_paginate', '~> 3.0.5'
gem 'will_paginate-bootstrap'
gem 'chosen-rails', '1.3.0'
gem 'newrelic_rpm'
gem 'puma'

# Environment Dependencies
group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'coveralls', require: false

  gem 'grape'
  gem 'grape-raketasks'
  gem 'grape-entity'
end

group :test do
  gem 'capybara'
  gem "codeclimate-test-reporter", require: nil
  gem 'database_cleaner'
  gem 'faker'
  gem 'shoulda'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'bugsnag'
  gem 'analytics-ruby', '~> 2.0.0', :require => 'segment/analytics'
end