module ManagementModule
  class EmployeesController < ApplicationController
    def index
      @employees = current_cooperative.users
    end

    def new
      @employee = current_cooperative.users.new
    end

    def create
      @employee = current_cooperative.users.create(employee_params)
      if @employee.valid?
        @employee.save
        redirect_to employee_url(@employee), notice: "Employee registered successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @employee = current_cooperative.users.find(params[:id])
    end

    private

    def employee_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
    end
  end
end
