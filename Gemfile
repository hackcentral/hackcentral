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
gem 'bugsnag'
gem 'analytics-ruby', '~> 2.0.0', :require => 'segment/analytics'

# Environment Dependencies
group :development, :test do
  gem 'sqlite3'
  gem 'capistrano', '2.11.2'
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
  gem 'unicorn'
  gem 'pg'
  gem 'rails_12factor'

end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
