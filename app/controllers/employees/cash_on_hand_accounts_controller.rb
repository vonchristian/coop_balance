module Employees
  class CashOnHandAccountsController < ApplicationController
    def edit
      @employee = User.find(params[:employee_id])
    end

    def update
      @employee = User.find(params[:employee_id])
      @employee.update_attributes(employee_params)
      if @employee.save
        redirect_to employee_url(@employee), notice: "Cash on Hand Account saved successfully."
      else
        render :new
      end
    end


    private
    def employee_params
      params.require(:user).permit(:cash_on_hand_account_id)
    end
  end
end
