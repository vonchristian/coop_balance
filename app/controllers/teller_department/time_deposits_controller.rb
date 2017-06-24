module TellerDepartment
  class TimeDepositsController < ApplicationController
    def index
      @time_deposits = TimeDeposit.all
    end
  end
end
