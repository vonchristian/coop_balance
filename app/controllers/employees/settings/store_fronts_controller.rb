module Employees
  module Settings
    class StoreFrontsController < ApplicationController
      respond_to :html, :json
      def edit
        @employee = current_cooperative.users.find(params[:employee_id])
        respond_modal_with @employee
      end
      def update
        @employee = current_cooperative.users.find(params[:employee_id])
        @employee.update(store_front_id: params[:user][:store_front_id])
        respond_modal_with @employee, location: employee_settings_url(@employee), notice: "Store Front set successfully."
      end
    end
  end
end
