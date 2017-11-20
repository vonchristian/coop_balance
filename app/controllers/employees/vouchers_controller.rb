module Employees
  class VouchersController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
    end
    def new
      @employee = User.find(params[:employee_id])
      @amount = Vouchers::VoucherAmount.new
      @voucher = Voucher.new
    end
    def create
       @employee = User.find(params[:employee_id])
      @voucher = Voucher.create(voucher_params)
      if @voucher.save
        @voucher.add_amounts(@employee)
        redirect_to employee_vouchers_url(@employee), notice: "Voucher created successfully."
      else
        render :new
      end
    end

    private
    def voucher_params
      params.require(:voucher).permit(:date, :payee_id, :description, :payee_type, :voucherable_id, :description, :voucherable_type, :user_id, :number, :preparer_id)

    end
  end
end
