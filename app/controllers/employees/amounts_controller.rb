module Employees
  class AmountsController < ApplicationController
    def create
      @employee = User.find(params[:employee_id])
      @amount = VoucherAmount.create(amount_params)
      @amount.commercial_document = @employee
      @amount.save
      redirect_to new_employee_voucher_url(@employee), notice: "Added successfully."
    end
    def destroy
      @employee = User.find(params[:employee_id])
      @voucher_amount = VoucherAmount.find(params[:id])
      @voucher_amount.destroy
      redirect_to new_employee_voucher_url(@employee), notice:"Removed successfully."
  end
    private
    def amount_params
      params.require(:voucher_amount).permit(:amount, :account_id, :description)
    end
  end
end
