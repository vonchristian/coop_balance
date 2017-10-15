module HrModule 
  class AmountsController < ApplicationController
    def new 
      @employee = User.find(params[:id])
      @amount = VoucherAmount.new 
    end 
    def create 
      @employee = User.find(params[:id])
      @amount = VoucherAmount.create(amount_params)
      if @amount.save 
        redirect_to hr_module_employee_payrolls_url(@employee), notice: "Payroll created successfully."
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