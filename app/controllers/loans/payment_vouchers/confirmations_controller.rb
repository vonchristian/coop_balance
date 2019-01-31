module Loans
  module PaymentVouchers
    class ConfirmationsController < ApplicationController
      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @voucher = Voucher.find(params[:payment_voucher_id])
        @schedule = LoansModule::AmortizationSchedule.find(params[:schedule_id])
        Vouchers::EntryProcessing.new(
          voucher:    @voucher,
          employee:   current_user,
          updateable: @loan
        ).process!
        LoansModule::AmortizationPaymentUpdater.new(
          loan:     @loan,
          schedule: @schedule,
          voucher:  @voucher
        ).update_status!

        redirect_to loan_payments_url(@loan), notice: "Payment saved successfully."
      end
    end
  end
end