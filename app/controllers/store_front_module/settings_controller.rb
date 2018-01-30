module StoreFrontModule
  class SettingsController < ApplicationController
    def index
      authorize [:store_front_module, :settings]
    end
  end
end
