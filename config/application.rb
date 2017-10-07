require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Coopcatalyst
  class Application < Rails::Application
    config.assets.precompile << 'delayed/web/application.css'
    # Initialize configuration defaults for originally generated Rails version.
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
    config.time_zone = 'Asia/Manila'
    config.active_record.default_timezone = :local
    config.active_job.queue_adapter = :delayed_job

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end