class EmployeesController < ApplicationController 
  def show 
    @employee = User.find(params[:id])
  end 
end 