source 'https://rubygems.org'
ruby '2.7.2'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
gem 'mime-types', [ '~> 2.6', '>= 2.6.1' ], require: 'mime/types/columnar'
gem 'prawn-icon'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'webpacker', '~> 4.x'
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'trix'
gem 'autonumeric-rails'
gem 'rails'
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
gem 'mina-puma',     require: false
gem 'mina-whenever', require: false
gem 'barby'
gem 'rqrcode'
gem 'prawn-print'
gem 'dotiw'
gem "spreadsheet"
gem 'delayed-web'
gem 'mini_magick'
gem 'chartkick'
gem 'groupdate'
gem 'roo', "2.7.0"
gem 'numbers_and_words'
gem "audited", "~> 4.9"
gem "responders"
gem 'money-rails'
gem 'sidekiq', '<7'
gem "gretel"
gem 'fast_jsonapi'
gem 'pagy'
gem 'letter_opener'
gem 'email_spec'
gem 'whenever', require: false
gem "select2-rails"
gem "simple_calendar"
gem "facebook-messenger"

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
end

group :test do
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'database_rewinder'
  gem 'pundit-matchers'
  gem 'webdrivers', '~> 4.0'
end

gem 'rack-mini-profiler', require: false
gem 'flamegraph'
gem 'memory_profiler'
gem 'stackprof'
