source 'https://rubygems.org'
ruby '2.4.2'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
gem 'bootsnap', require: false
gem 'trix'
gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7', group: [:development, :production]
gem 'sass-rails', '>= 3.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 3.0'
gem 'devise'
gem 'simple_form'
gem "select2-rails"
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'icheck-rails'
gem 'friendly_id'
gem 'font-awesome-rails'
gem 'bootstrap-datepicker-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
gem 'dragonfly'
gem 'pg_search'
gem 'will_paginate', '~> 3.1.0'
gem 'paperclip'
gem 'avatar_magick', '~> 1.0.1'
gem 'pundit'
gem 'prawn'
gem 'prawn-table'
gem 'prawn-qrcode'
gem "gretel"
gem 'public_activity'
gem 'mina-puma', require: false
gem 'barby'
gem 'rqrcode'
gem 'prawn-print'
gem 'delayed_job_active_record'
gem 'simple-line-icons-rails'
gem 'dotiw'
gem "spreadsheet"
gem 'daemons'
gem 'delayed-web'
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rspec-its'
  gem 'faker'
end

group :development do
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'bullet'
end
group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-webkit'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'rack-mini-profiler'
gem 'memory_profiler'
gem 'whenever', :require => false

gem "simple_calendar", "~> 2.0"