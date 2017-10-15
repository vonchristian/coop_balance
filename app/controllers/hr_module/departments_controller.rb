module HrModule 
  class DepartmentsController < ApplicationController
    def new 
      @department = Department.new 
    end 
    def create 
      @department = Department.create(department_params)
      if @department.save 
        redirect_to hr_module_settings_url, notice: "Department created successfully."
      else 
        render :new 
      end 
    end 

    private 
    def department_params
      params.require(:department).permit(:name)
    end 
  end 
end 