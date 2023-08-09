module ManagementModule 
  module Settings
    class EmployeesController < ApplicationController
      def new 
        @employee = User.new 
      end 
      def create 
        @employee = User.create(employee_params)
        if @employee.valid?
          @employee.save 
          redirect_to management_module_settings_employees_url, notice: "Employee registered successfully."
        else 
          render :new, status: :unprocessable_entity
        end 
      end 
      def show 
        @employee = User.find(params[:id])
      end

      private 
      def employee_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
      end 
    end 
  end
end 