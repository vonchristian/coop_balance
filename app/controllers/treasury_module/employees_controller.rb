module TreasuryModule
  class EmployeesController < ApplicationController
    def index
      @employees = current_cooperative.users
    end

    def show
      @employee = current_cooperative.users.find(params[:id])
    end
  end
end
