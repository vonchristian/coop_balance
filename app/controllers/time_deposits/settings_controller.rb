module TimeDeposits
  class SettingsController < ApplicationController
    def index
      @time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
    end
  end
end
