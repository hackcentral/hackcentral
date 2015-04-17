source 'https://rubygems.org'

ruby '2.2.2'

# Rails Dependencies
gem 'rails'
gem 'sass-rails', '5.0.1'
gem 'uglifier', '2.7.0'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.3'
gem 'turbolinks'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development

# HC Dependencies
  # Image Upload
gem 'aws-sdk', '1.60.2'
gem 'paperclip'

  # Assets
gem 'bootstrap-sass'
gem 'chosen-rails', '1.3.0'
gem 'font-awesome-sass'
gem 'will_paginate', '~> 3.0.5'
gem 'will_paginate-bootstrap'

  # Auth
gem 'devise'
gem 'doorkeeper', '2.1.3'

  # Utilities
gem 'conred'
gem 'delayed_job_active_record'
gem 'figaro'
gem 'friendly_id'
gem 'local_time'
gem 'rails_admin'

  # Server Stuff
gem 'newrelic_rpm'
gem 'puma'
gem 'bugsnag'
gem 'analytics-ruby', '~> 2.0.0', :require => 'segment/analytics'

  # Grape
gem 'grape'
gem 'grape-raketasks'
gem 'grape-entity'
gem 'wine_bouncer', github: 'antek-drzewiecki/wine_bouncer'

# Environment Dependencies
group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'coveralls', require: false
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
end