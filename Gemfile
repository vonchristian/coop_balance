source 'https://rubygems.org'
ruby '3.2.2'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'jsbundling-rails'
gem 'ancestry'
gem 'active_interaction', '~> 5.3'
gem 'active_interaction-extras'
gem 'prawn-icon'
gem 'bootsnap',  require: false
gem 'caxlsx', '~> 3.0'
gem 'caxlsx_rails'
gem 'trix'
gem 'autonumeric-rails'
gem "rails", "~> 7.0.5"
gem "pg", "~> 1.1"
gem 'puma', group: [:development, :production]
gem 'sass-rails', '~> 5'
gem 'turbo-rails'
gem "stimulus-rails"
gem "cssbundling-rails", "~> 1.2"
gem 'jbuilder'
gem 'redis'
gem 'devise'
gem 'simple_form'
gem 'friendly_id'
gem 'pg_search'
gem 'will_paginate'
gem 'pundit'
gem 'prawn'
gem 'prawn-table'
gem 'prawn-qrcode'
gem 'mina-ng-puma', require: false
gem 'mina-whenever', require: false
gem 'barby'
gem 'rqrcode'
gem 'prawn-print'
gem 'dotiw'
gem "spreadsheet"
gem 'mini_magick'
gem 'chartkick'
gem 'groupdate'
gem 'roo', "2.7.0"
gem 'numbers_and_words'
gem 'money-rails'
gem 'sidekiq', '<7'
gem "gretel"
gem 'pagy'
gem 'whenever', require: false
gem "select2-rails"
gem "sprockets-rails"
gem 'bootstrap', '~> 5.3.0.alpha3'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem "bullet"

end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'derailed_benchmarks'
  gem 'rubocop', require: false             # https://github.com/rubocop/rubocop
  gem 'rubocop-performance', require: false # https://github.com/rubocop/rubocop-performance
  gem 'rubocop-rails', require: false       # https://github.com/rubocop/rubocop-rails
  gem 'rubocop-rspec', require: false       # https://github.com/rubocop/rubocop-rspec
end

group :test do
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'database_rewinder'
  gem 'pundit-matchers'
  gem 'webdrivers', '~> 4.0'
end

gem 'rack-mini-profiler', require: false


gem "matrix", "~> 0.4.2"
