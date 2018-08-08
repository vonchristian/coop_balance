module ShareCapitals
  class SettingsController < ApplicationController
    def index
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
    end
  end
end
