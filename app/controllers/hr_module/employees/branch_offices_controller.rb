module HrModule
  module Employees
    class BranchOfficesController < ApplicationController
      def edit
        @employee = User.find(params[:employee_id])
      end
      def update
        @employee = User.find(params[:employee_id])
        @employee.update(share_capital_params)
        if @employee.save
          redirect_to hr_module_employee_url(@employee), notice: "Branch Office updated successfully"
        else
          render :new
        end
      end

      private
      def share_capital_params
        params.require(:user).permit(:branch_office_id)
      end
    end
  end
end
