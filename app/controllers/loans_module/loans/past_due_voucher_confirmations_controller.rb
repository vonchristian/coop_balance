module LoansModule
  module Loans
    class PastDueVoucherConfirmationsController < ApplicationController
      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @voucher = current_cooperative.vouchers.find(params[:voucher_id])
        LoansModule::Loans::PastDueVoucherConfirmationProcessing.new(voucher: @voucher, employee: current_user, loan: @loan).process!
        redirect_to loan_url(@loan), notice: 'Loan set as past due successfully.'
      end
    end
  end
end
