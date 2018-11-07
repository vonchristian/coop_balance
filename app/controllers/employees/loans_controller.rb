module Employees
  class LoansController < ApplicationController
    def index
      @employee = current_cooperative.users.find(params[:employee_id])
    end
    def new
      @employee = current_cooperative.users.find(params[:employee_id])
      @loan = @employee.loans.build
    end
  end
end
