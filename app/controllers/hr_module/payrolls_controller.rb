module HrModule 
  class PayrollsController < ApplicationController
    def index 
      @employee = User.find(params[:employee_id])
    end 
    def new 
      @employee = User.find(params[:employee_id])
      @amount = VoucherAmount.new
      @voucher = Voucher.new
    end
    def create
      @employee = User.find(params[:employee_id])
      @amount = VoucherAmount.create(amount_params)
      if @amount.save 
        redirect_to new_hr_module_employee_payroll_url(@employee), notice: "added successfully"
      else 
        render :new 
      end 
    end 

    private 
    def amount_params
      params.require(:voucher_amount).permit(:amount, :description, :account_id)
    end
  end 
end 