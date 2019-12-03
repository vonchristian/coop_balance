require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CoopBooks
  class Application < Rails::Application
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.time_zone = 'Asia/Manila'
    config.active_record.default_timezone = :utc
    config.beginning_of_week = :sunday
  end
end
