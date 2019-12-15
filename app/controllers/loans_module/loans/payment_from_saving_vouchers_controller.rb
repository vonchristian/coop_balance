module LoansModule
  module Loans
    class PaymentFromSavingVouchersController < ApplicationController
      def create
        @loan            = current_office.loans.find(params[:loan_id])
        @payment_voucher = LoansModule::Loans::PaymentFromSavingVoucher.new(voucher_params)
        if @payment_voucher.valid?
          @payment_voucher.process!
          @voucher = current_office.vouchers.find_by(account_number: params[:loans_module_loans_payment_from_saving_voucher][:account_number])
          redirect_to loans_module_loan_payment_from_saving_voucher_url(loan_id: @loan.id, id: @voucher.id), notice: 'Journal entry voucher created successfully'
        else
          redirect_to new_loans_module_loan_payment_from_saving_url(@loan), alert: 'Error'
        end
      end

      def show
        @loan    = current_office.loans.find(params[:loan_id])
        @voucher = current_office.vouchers.find(params[:id])
      end 

      private
      def voucher_params
        params.require(:loans_module_loans_payment_from_saving_voucher).
        permit(:date, :description, :account_number, :reference_number, :loan_id, :cart_id, :employee_id, :account_number)
      end
    end
  end
end
