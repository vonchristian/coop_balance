module TellerModule
  class TimeDepositsController < ApplicationController
    def index
      @time_deposits = MembershipsModule::TimeDeposit.all
    end
  end
end
