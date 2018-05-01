module TimeDeposits
  class SettingsController < ApplicationController
    def index
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
    end
  end
end
