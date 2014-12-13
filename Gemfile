source 'https://rubygems.org'

# Rails Dependencies
gem 'rails', '4.1.7'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
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

# Environment Dependencies
group :development, :test do
  gem 'sqlite3'
  gem 'thin'
  gem 'capistrano', '2.11.2'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'unicorn'
  gem 'actionmailer', :require => 'action_mailer'
  gem 'remote_syslog_logger', :require => 'remote_syslog_logger'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
