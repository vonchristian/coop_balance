module ShareCapitals
  class SettingsController < ApplicationController
    def index
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
    end
  end
end
