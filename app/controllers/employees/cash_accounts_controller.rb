module Employees
  class CashAccountsController < ApplicationController
    def new
      @employee = User.find(params[:employee_id])
      @cash_account = @employee.employee_cash_accounts.build
    end
    def create
      @employee = User.find(params[:employee_id])
      @cash_account = @employee.employee_cash_accounts.create(cash_account_params)
      @cash_account.save
      redirect_to employee_settings_url(@employee), notice: "Cash Account saved successfully."
    end

    def destroy
      @employee = User.find(params[:employee_id])
      @cash_account = @employee.employee_cash_accounts.find(params[:id])
      @cash_account.destroy
      redirect_to employee_settings_url(@employee), notice: "Removed successfully"
    end
    private
    def cash_account_params
      params.require(:employees_employee_cash_account).permit(:cash_account_id)
    end
  end
end
