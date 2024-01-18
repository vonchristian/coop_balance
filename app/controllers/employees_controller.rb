class EmployeesController < ApplicationController
  respond_to :html, :json

  def index
    @employees = current_cooperative.users
  end

  def show
    @employee = current_cooperative.users.find(params[:id])
  end

  def edit
    @employee = current_cooperative.users.find(params[:id])
    respond_modal_with @employee
  end

  def update
    @employee = current_cooperative.users.find(params[:id])
    @employee.update(employee_params)
    respond_modal_with @employee,
                       location: employee_url(@employee)
  end

  private

  def employee_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :designation, :role)
  end
end
