module Employees
  class CashOnHandAccountsController < ApplicationController
    def edit
      @employee = current_cooperative.users.find(params[:employee_id])
    end

    def update
      @employee = current_cooperative.users.find(params[:employee_id])
      @employee.update(employee_params)
      if @employee.save
        redirect_to employee_url(@employee), notice: "Cash on Hand Account saved successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end


    private
    def employee_params
      params.require(:user).permit(:cash_on_hand_account_id)
    end
  end
end
