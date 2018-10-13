module Employees
  class TimeDepositsController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
      @time_deposits = @employee.time_deposits
    end
  end
end
