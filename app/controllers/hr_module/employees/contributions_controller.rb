module HrModule 
  module Employees
    class ContributionsController < ApplicationController
      def new 
        @employee = User.find(params[:employee_id])
        @contribution = @employee.employee_contributions.build
      end 
      def create 
         @employee = User.find(params[:employee_id])
        @contribution = @employee.employee_contributions.create(contribution_params)
          redirect_to new_hr_module_employee_contribution_url(@employee), notice: "Contribution added successfully"
      end
      private 
      def contribution_params
        params.require(:employee_contribution).permit(:contribution_id)
      end 
    end 
  end 
end
