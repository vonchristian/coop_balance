class EmployeesController < ApplicationController
  def index
    @employees = current_cooperative.users
  end
  def show
    @employee = current_cooperative.users.find(params[:id])
  end
  def edit
    @employee = current_cooperative.users.find(params[:id])
  end
  def update
    @employee = current_cooperative.users.find(params[:id])
    @employee.update(employee_params)
    if @employee.valid?
      @employee.save
      redirect_to employee_url(@employee), notice: "updated successfully"
    else
      render :edit
    end
  end

  private
  def employee_params
    params.require(:user).permit(:avatar, :email, :password, :password_confirmation, :role)
  end
end
