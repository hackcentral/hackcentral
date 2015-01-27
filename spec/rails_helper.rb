if ENV["codeclimate_repo_token"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.configure do |config|
    config.logger.level = Logger::WARN
  end
  CodeClimate::TestReporter.start
end


ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "capybara/rspec"
require 'shoulda/context'
require 'shoulda/matchers'
require 'coveralls'
  Coveralls.wear!('rails')
require 'paperclip/matchers'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.extend ControllerMacros, :type => :controller

  config.include Paperclip::Shoulda::Matchers
end
