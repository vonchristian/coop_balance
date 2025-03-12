module Employees
  class AmountsController < ApplicationController
    def create
      @employee = current_cooperative.users.find(params[:employee_id])
      @amount = current_cooperative.voucher_amounts.create(amount_params)
      @amount.save
      redirect_to new_employee_voucher_url(@employee), notice: "Added successfully."
    end

    def destroy
      @employee = current_cooperative.users.find(params[:employee_id])
      @voucher_amount = current_cooperative.voucher_amounts.find(params[:id])
      @voucher_amount.destroy
      redirect_to new_employee_voucher_url(@employee), notice: "Removed successfully."
    end

    private

    def amount_params
      params.require(:vouchers_voucher_amount).permit(:amount, :account_id, :description, :amount_type)
    end
  end
end
