source "https://rubygems.org"
ruby "3.4.2"
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 8.0"

gem "active_interaction", "~> 5.3"
gem "active_interaction-extras"
gem "ancestry"
gem "autonumeric-rails"
gem "barby"
gem "bootsnap", require: false
gem "bootstrap"
gem "caxlsx"
gem "caxlsx_rails"
gem "chartkick"
gem "cssbundling-rails"
gem "devise"
gem "dotiw"
gem "friendly_id"
gem "gretel"
gem "groupdate"
gem "jbuilder"
gem "jsbundling-rails"
gem "mina-ng-puma", require: false
gem "mina-whenever", require: false
gem "mini_magick"
gem "money-rails"
gem "numbers_and_words"
gem "pagy"
gem "pg", "~> 1.1"
gem "pg_search"
gem "prawn"
gem "prawn-icon"
gem "prawn-print"
gem "prawn-qrcode"
gem "prawn-table"
gem "puma"
gem "pundit"
gem "redis"
gem "roo"
gem "rqrcode"
gem "select2-rails"
gem "simple_form"
gem "spreadsheet"
gem "stimulus-rails"
gem "trix"
gem "whenever", require: false
gem "will_paginate"
gem "propshaft"
gem "importmap-rails"
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

group :development, :test do
  gem "bullet"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-rails"
  gem "rspec-rails"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "database_cleaner-active_record"
  gem "pundit-matchers"
  gem "shoulda-matchers"
  gem "webdrivers", "~> 4.0"
  gem "simplecov", require: false
end

gem "rack-mini-profiler", require: false

gem "matrix", "~> 0.4.2"
gem "csv"

gem "tailwindcss-ruby", "~> 4.0", ">= 4.0.9"

gem "tailwindcss-rails", "~> 4.1"
gem "responders"

gem "nokogiri", "~>1.15"


# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
