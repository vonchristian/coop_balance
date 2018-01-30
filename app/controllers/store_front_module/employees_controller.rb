module StoreFrontModule
  class EmployeesController < ApplicationController
    def show
      @employee = current_user
    end
  end
end
