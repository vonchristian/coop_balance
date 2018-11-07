module Employees
  class VouchersController < ApplicationController
    def index
      @employee = current_cooperative.users.find(params[:employee_id])
    end
    def new
      @employee = current_cooperative.users.find(params[:employee_id])
      @amount = Vouchers::VoucherAmount.new
      @voucher = Vouchers::EmployeeVoucher.new
    end
    def create
       @employee = current_cooperative.users.find(params[:employee_id])
      @voucher = Vouchers::EmployeeVoucher.create(voucher_params)
      if @voucher.save
        @voucher.add_amounts(@employee)
        redirect_to employee_vouchers_url(@employee), notice: "Voucher created successfully."
      else
        render :new
      end
    end

    private
    def voucher_params
      params.require(:vouchers_employee_voucher).permit(:date, :payee_id, :description, :payee_type, :voucherable_id, :description, :voucherable_type, :user_id, :number, :preparer_id)

    end
  end
end
