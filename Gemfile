source 'https://rubygems.org'
ruby '2.6.5'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
gem 'mime-types', [ '~> 2.6', '>= 2.6.1' ], require: 'mime/types/columnar'
gem 'prawn-icon'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'webpacker', '~> 4.x'
gem 'rubyzip', '>= 1.2.2'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'axlsx_rails'
gem 'trix'
gem 'autonumeric-rails'
gem 'rails', '~> 6.0.0'
gem 'pg', '0.21'
gem 'pghero'
gem 'pg_query'
gem 'puma', group: [:development, :production]
gem 'sass-rails', '~> 5'
gem 'uglifier'
gem "paperclip", "~> 6.1.0"
gem 'coffee-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder'
gem 'redis'
gem 'devise'
gem 'devise_invitable'
gem 'simple_form'
gem 'friendly_id'
gem 'font-awesome-sass'

gem 'pg_search'
gem 'will_paginate'
gem 'pundit'
gem 'prawn'
gem 'prawn-table'
gem 'prawn-qrcode'
gem 'public_activity'
gem 'mina-puma', require: false
gem 'mina-whenever', require: false
gem 'barby'
gem 'rqrcode'
gem 'prawn-print'
gem 'delayed_job_active_record'
gem 'dotiw'
gem "spreadsheet"
gem 'delayed-web'
gem 'mini_magick'
gem 'chartkick'
gem 'groupdate'
gem "highcharts-rails"
gem 'roo', "2.7.0"
gem 'chronic'
gem 'numbers_and_words'
gem "audited", "~> 4.9"
gem "responders"
gem 'money-rails'

gem "gretel"
gem 'webdack-uuid_migration'
gem 'fast_jsonapi'
gem 'pagy'
gem 'letter_opener'
gem 'email_spec'
gem 'whenever', require: false
gem "select2-rails"

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'bullet'
  gem 'pry-rails'
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'database_rewinder'
  gem 'pundit-matchers'
  gem 'webdrivers', '~> 4.0'
end

gem 'rack-mini-profiler', require: false
gem "simple_calendar"
gem 'traceroute'
