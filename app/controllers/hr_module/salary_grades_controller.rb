module HrModule 
  class SalaryGradesController < ApplicationController
    def new 
      @salary_grade = SalaryGrade.new 
      authorize [:hr_module, @salary_grade]
    end 
    def create
      @salary_grade = SalaryGrade.new 
      authorize [:hr_module, @salary_grade]
      @salary_grade.update(salary_grade_params)
      if @salary_grade.valid?
        @salary_grade.save 
        redirect_to hr_module_settings_url, notice: "Salary Grade created successfully."
      else 
        render :new 
      end 
    end 

    private 
    def salary_grade_params
      params.require(:salary_grade).permit(:name, :amount)
    end 
  end 
end 