module LoansModule
  module Loans
    class PaymentVoucherConfirmationsController < ApplicationController
      def create
        @loan = current_office.loans.find(params[:loan_id])
        @voucher = current_office.vouchers.find(params[:voucher_id])
        ApplicationRecord.transaction do
          Vouchers::EntryProcessing.new(updateable: @loan, voucher: @voucher, employee: current_user).process!
        end

        redirect_to loans_module_loan_accounting_index_url(@loan), notice: 'Transaction confirmed successfully.'
      end
    end
  end
end
