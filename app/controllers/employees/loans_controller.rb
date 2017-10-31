module Employees
  class LoansController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
    end
    def new
      @employee = User.find(params[:employee_id])
      @loan = @employee.loans.build
    end
  end
end
