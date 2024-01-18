module StoreFrontModule
  class SettingsController < ApplicationController
    def index
      authorize %i[store_front_module settings]
    end
  end
end
