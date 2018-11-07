module Employees
  class CashAccountsController < ApplicationController
    respond_to :html, :json

    def new
      @employee = current_cooperative.users.find(params[:employee_id])
      @cash_account = @employee.employee_cash_accounts.build
      respond_modal_with @cash_account
    end
    def create
      @employee = current_cooperative.users.find(params[:employee_id])
      @cash_account = @employee.employee_cash_accounts.create(cash_account_params)
      @cash_account.save
      respond_modal_with @cash_account, location: employee_settings_url(@employee), notice: "Cash Account saved successfully."
    end

    def destroy
      @employee = current_cooperative.users.find(params[:employee_id])
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
