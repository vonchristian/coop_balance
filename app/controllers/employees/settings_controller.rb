module Employees
  class SettingsController < ApplicationController
    def index
      @employee = current_cooperative.users.find(params[:employee_id])
    end
  end
end
