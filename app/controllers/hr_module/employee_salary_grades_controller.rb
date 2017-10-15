module HrModule 
  class EmployeeSalaryGradesController < ApplicationController
    def edit 
      @employee = User.find(params[:id])
    end 
    def update
      @employee = User.find(params[:employee_id])
      @employee.update(employee_salary_grade_params)
      if @employee.save 
        redirect_to hr_module_employee_url(@employee), notice: "Salary Grade set successfully."
      else 
        render :new 
      end 
    end 

    private 
    def employee_salary_grade_params
      params.require(:user).permit(:salary_grade_id)
    end 
  end 
end 
