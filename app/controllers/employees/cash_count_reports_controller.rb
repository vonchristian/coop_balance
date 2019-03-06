module Employees
  class CashCountReportsController < ApplicationController
    def new
      @employee = User.find(params[:employee_id])
      @cash_count = CashCount.new
      @bills = Bill.all 
    end
  end
end
