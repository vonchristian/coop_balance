module LoansModule
  module LoanMultipleTransactions
    class ConfirmationsController < ApplicationController
      def create
        @voucher = current_office.vouchers.find(params[:voucher_id])
        Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
        LoansModule::Loans::BatchPaidAtUpdater.new(voucher: @voucher).update_loans!
        redirect_to vouchers_url, notice: "Transaction confirmed successfully."
      end
    end
  end
end
