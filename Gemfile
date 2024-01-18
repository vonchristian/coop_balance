source 'https://rubygems.org'
ruby '3.3.0'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_interaction', '~> 5.3'
gem 'active_interaction-extras'
gem 'ancestry'
gem 'autonumeric-rails'
gem 'barby'
gem 'bootsnap', require: false
gem 'bootstrap', '~> 5.3.0.alpha3'
gem 'caxlsx', '~> 3.0'
gem 'caxlsx_rails'
gem 'chartkick'
gem 'cssbundling-rails', '~> 1.2'
gem 'devise', github: 'heartcombo/devise', branch: 'main'
gem 'dotiw'
gem 'friendly_id'
gem 'gretel'
gem 'groupdate'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'mina-ng-puma', require: false
gem 'mina-whenever', require: false
gem 'mini_magick'
gem 'money-rails'
gem 'numbers_and_words'
gem 'pagy'
gem 'pg', '~> 1.1'
gem 'pg_search'
gem 'prawn'
gem 'prawn-icon'
gem 'prawn-print'
gem 'prawn-qrcode'
gem 'prawn-table'
gem 'puma', group: %i[development production]
gem 'pundit'
gem 'rails', '~> 7.1', '>= 7.1.2'
gem 'redis'
gem 'roo', '2.7.0'
gem 'rqrcode'
gem 'sass-rails', '~> 5'
gem 'select2-rails'
gem 'sidekiq', '<7'
gem 'simple_form'
gem 'spreadsheet'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'trix'
gem 'turbo-rails'
gem 'whenever', require: false
gem 'will_paginate'

group :development, :test do
  gem 'bullet'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :development do
  gem 'derailed_benchmarks'
  gem 'listen'
  gem 'rubocop', require: false             # https://github.com/rubocop/rubocop
  gem 'rubocop-performance', require: false # https://github.com/rubocop/rubocop-performance
  gem 'rubocop-rails', require: false       # https://github.com/rubocop/rubocop-rails
  gem 'rubocop-rspec', require: false       # https://github.com/rubocop/rubocop-rspec
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara'
  gem 'database_rewinder'
  gem 'pundit-matchers'
  gem 'shoulda-matchers'
  gem 'webdrivers', '~> 4.0'
end

gem 'rack-mini-profiler', require: false

gem 'matrix', '~> 0.4.2'
gem 'sassc-rails'
