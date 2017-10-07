# workers 2
# threads 2,8

# environment 'production'
# directory '/var/www/coopcatayst/current'
# shared_dir = File.expand_path("../..", __FILE__)

# stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# rackup DefaultRackup
# bind "unix://#{shared_dir}/tmp/sockets/puma.sock"
# pidfile "#{shared_dir}/tmp/pids/puma.pid"

# prune_bundler

