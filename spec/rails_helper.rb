# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require "paperclip/matchers"
require 'database_cleaner'

Dir[Rails.root.join("spec/models/shared_examples/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Paperclip::Shoulda::Matchers
  config.include FactoryBot::Syntax::Methods
  config.include Warden::Test::Helpers
  config.include Devise::Test::IntegrationHelpers, :type => :system
  config.include Devise::Test::ControllerHelpers, :type => :views
  config.include Devise::Test::ControllerHelpers, :type => :controllers
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction

  end
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Capybara.javascript_driver = :webkit
