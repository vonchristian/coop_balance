module HrModule 
  class EmployeesController < ApplicationController
    def index 
      @employees = User.all 
    end 
    def new 
      @employee = User.new 
    end 
    def create 
      @employee = User.create(employee_params)
      if @employee.save 
        redirect_to hr_module_employee_url(@employee), notice: "Employee saved successfully."
      else 
        render :new 
      end 
    end 
    def show 
      @employee = User.find(params[:id])
    end
    def edit
      @employee = User.find(params[:id])
    end
    def update 
      @employee = User.find(params[:id])
      @employee.update(employee_params)
      if @employee.save 
        redirect_to hr_module_employee_url(@employee), notice: "Employee information updated successfully."
      else 
        render :new 
      end
    end

    private 
    def employee_params
      params.require(:user).permit(:first_name, :last_name, :contact_number, :email, :sex, :date_of_birth, :role, :password, :password_confirmation, :avatar)
    end
  end 
end 