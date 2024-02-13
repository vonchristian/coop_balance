# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'money-rails/test_helpers'
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/models/shared_examples/**/*.rb')].each { |f| require f }

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require 'pundit/rspec'
require 'webdrivers'
require 'simplecov'
SimpleCov.start

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryBot::Syntax::Methods
  config.include Warden::Test::Helpers
  config.example_status_persistence_file_path = 'spec/failed_tests.txt'

  config.after do
    DatabaseRewinder.clean
  end
  config.before(:each, type: :system) do
    driven_by :rack_test, using: :firefox
  end

  config.before(:each, :js, type: :system) do
    driven_by :selenium_chrome
  end
  config.before(:suite) do
    DatabaseRewinder.clean_all
    FactoryBot.reload
  end
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
class ActiveModel::SecurePassword::InstanceMethodsOnActivation; end
Capybara.raise_server_errors = false
