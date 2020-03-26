require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kiphodan
  class Application < Rails::Application
    config.load_defaults 6.0
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.time_zone = 'Asia/Manila'
    config.active_record.default_timezone = :utc
    config.beginning_of_week = :sunday
    config.autoload_paths << Rails.root.join('workers')
    config.autoload_paths << Rails.root.join('bot')
  end
end
Rails.autoloaders.main.ignore(Rails.root.join('app/node_modules'))
