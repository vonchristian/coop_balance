module Employees
  class AvatarsController < ApplicationController
    def update
      @employee = current_cooperative.users.find(params[:employee_id])
      @avatar = @employee.update(avatar_params)
      redirect_to employee_url(@employee), notice: 'Avatar updated.'
    end

    private

    def avatar_params
      params.require(:user).permit(:avatar)
    end
  end
end
