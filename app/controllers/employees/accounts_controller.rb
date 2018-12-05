module Employees
	class AccountsController < ApplicationController
		respond_to :html, :json

		def edit
			@employee = current_cooperative.users.find(params[:employee_id])
			respond_modal_with @employee
		end

		def update
			@employee = current_cooperative.users.find(params[:employee_id])
			@employee.update(password_params)
			respond_modal_with @employee, 
				location: employee_settings_url(@employee)
		end

		private
    def password_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
		
	end
end