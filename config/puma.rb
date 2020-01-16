workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

environment 'production'
directory '/var/www/rbg/current'
shared_dir = File.expand_path("../..", __FILE__)

stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

rackup DefaultRackup
bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
pidfile "#{shared_dir}/tmp/pids/puma.pid"

prune_bundler
preload_app!
on_worker_boot do
  ActiveRecord::Base.establish_connection
end
