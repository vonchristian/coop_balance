module ManagementModule 
	class EmployeesController < ApplicationController
		def index 
			@employees = User.all 
		end 
    def new 
      @employee = User.new 
    end 
    def create 
      @employee = User.create(employee_params)
      if @employee.valid?
        @employee.save 
        redirect_to employee_url(@employee), notice: "Employee registered successfully."
      else 
        render :new 
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