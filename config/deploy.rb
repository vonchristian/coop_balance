require 'mina/rails'
require 'mina/bundler'
require 'mina/git'
require 'mina/rbenv'
require 'mina/puma'

set :whenever_name, 'production'
set :domain,        '128.199.223.121'
set :deploy_to,     '/var/www/kiphodan'
set :repository,    'git@github.com:vonchristian/coop_balance.git'
set :branch,        'main'
set :user,          'deploy'
set :forward_agent, true
set :app_path,      -> { "#{fetch(:deploy_to)}/#{fetch(:current_path)}" }
set :stage,         'production'
set :shared_paths,  ['config/database.yml', 'log', 'tmp/log', 'public/system', 'tmp/pids', 'tmp/sockets', '/storage']
set :shared_dirs,   fetch(:shared_dirs, []).push('public/system', 'public/packs')

task :remote_environment do
  invoke :'rbenv:load'
end

desc 'Deploys the current version to the server.'
task deploy: :remote_environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    command "gem pristine nokogiri"
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      # invoke :'puma:hard_restart'
      # invoke :'whenever:update'
    end
  end
end

namespace :deploy do
  desc 'reload the database with seed data'
  task seed: :remote_environment do
    command "cd #{fetch(:current_path)}; bundle exec rails db:seed RAILS_ENV=#{fetch(:stage)}"
  end
end
