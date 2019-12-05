module Offices
  class SettingsController < ApplicationController
    def index
      @office = current_office
    end
  end
end
