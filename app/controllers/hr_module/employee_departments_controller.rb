module HrModule 
  class EmployeeDepartmentsController < ApplicationController
    def edit
      @employee = User.find(params[:id])
    end 
    def update
      @employee = User.find(params[:id])
      @employee.update(employee_params)
      if @employee.save 
        redirect_to hr_module_employee_url(@employee), notice: "Department set successfully"
      else 
        render :new 
      end 
    end 

    private 
    def employee_params
      params.require(:user).permit(:department_id)
    end 
  end 
end 