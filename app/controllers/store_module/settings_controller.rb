module StoreModule
  class SettingsController < ApplicationController
    def index
      authorize [:store_module, :settings]
    end
  end
end
