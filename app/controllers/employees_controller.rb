class EmployeesController < ApplicationController 
  def show 
    @employee = User.find(params[:id])
  end 
  def edit 
    @employee = User.find(params[:id])
  end 
  def update 
    @employee = User.find(params[:id])
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